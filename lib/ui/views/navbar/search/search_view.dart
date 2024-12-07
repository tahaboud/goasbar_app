import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:goasbar/data_models/experience_response.dart';
import 'package:goasbar/data_models/user_model.dart';
import 'package:goasbar/shared/app_configs.dart';
import 'package:goasbar/shared/colors.dart';
import 'package:goasbar/shared/ui_helpers.dart';
import 'package:goasbar/ui/views/confirm_booking/confirm_booking_view.dart';
import 'package:goasbar/ui/views/login/login_view.dart';
import 'package:goasbar/ui/views/navbar/search/search_viewmodel.dart';
import 'package:goasbar/ui/views/trip_detail/trip_detail_view.dart';
import 'package:goasbar/ui/widgets/creation_aware_item.dart';
import 'package:goasbar/ui/widgets/loader.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class SearchView extends HookWidget {
  const SearchView({super.key, this.isUser, this.user});
  final UserModel? user;
  final bool? isUser;

  @override
  Widget build(BuildContext context) {
    var minPrice = useTextEditingController();
    var maxPrice = useTextEditingController();
    var title = useTextEditingController();
    var filteredExperiences = useState<List<ExperienceResults>>([]);

    void filterExperiences(String genderConstraint, String from, String to,
        String city, String category) {
      String query = '?gender=$genderConstraint';

      if (from.isNotEmpty) {
        query = '$query&date_min=$from';
      }
      if (to.isNotEmpty) query = '$query&date_max=$to';

      if (city != "All cities") {
        query = '$query&city=$city';
      }

      if (title.text.isNotEmpty) {
        query = '$query&title=${title.text}';
      }

      if (minPrice.text.isNotEmpty) {
        query = '$query&price_min=${minPrice.text}';
      }
      if (maxPrice.text.isNotEmpty) {
        query = '$query&price_max=${maxPrice.text}';
      }

      if (category != "All categories") {
        query = '$query&category=$category';
      }

      SearchViewModel()
          .getPublicExperiences(
        query: query,
      )
          .then((value) {
        filteredExperiences.value = value!.results ?? [];
      });
    }

    return ViewModelBuilder<SearchViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalSpaceMedium,
                Text(
                  'Where are you going ?'.tr(),
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
                verticalSpaceMedium,
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                    hintText: 'Title'.tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: Image.asset("assets/icons/navbar/search.png"),
                    fillColor: kTextFiledGrayColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kTextFiledGrayColor),
                    ),
                  ),
                ),
                verticalSpaceRegular,
                Container(
                  height: 60,
                  width: screenWidthPercentage(context, percentage: 1),
                  decoration: BoxDecoration(
                    color: kTextFiledGrayColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      horizontalSpaceSmall,
                      horizontalSpaceTiny,
                      Image.asset("assets/icons/navbar/search.png"),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: model.city,
                              iconSize: 24,
                              icon: (null),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              onChanged: (value) => model.updateCity(
                                  value: value ?? "All cities"),
                              items: model
                                  .citiesWithNone()
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        onTap: () {},
                                        child: SizedBox(
                                          child: Text(
                                            c.tr(),
                                            style: const TextStyle(
                                                fontFamily: 'Cairo'),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpaceRegular,
                TextField(
                  readOnly: true,
                  controller: model.searchDate,
                  decoration: InputDecoration(
                    hintText: 'Search Date'.tr(),
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon:
                        Image.asset('assets/icons/birth_date.png').gestures(
                      onTap: () => model.showDateRangePicker(context),
                    ),
                    suffixIcon: model.searchDate.text.isNotEmpty
                        ? const Icon(Icons.clear).gestures(
                            onTap: () => model.clearSearchDate(),
                          )
                        : null,
                    fillColor: kTextFiledGrayColor,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: kTextFiledGrayColor),
                    ),
                  ),
                ),
                verticalSpaceRegular,
                Container(
                  height: 60,
                  width: screenWidthPercentage(context, percentage: 1),
                  decoration: BoxDecoration(
                    color: kTextFiledGrayColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      horizontalSpaceSmall,
                      horizontalSpaceTiny,
                      Image.asset("assets/icons/user_square.png"),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton<String>(
                              value: model.genderConstraint,
                              iconSize: 24,
                              icon: (null),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              onChanged: (value) =>
                                  model.updateGenderConstraint(
                                      value: value ?? "None"),
                              items: genderConstraints
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        onTap: () {},
                                        child: SizedBox(
                                          child: Text(
                                            c.tr(),
                                            style: const TextStyle(
                                                fontFamily: 'Cairo'),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                verticalSpaceRegular,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: screenWidthPercentage(context, percentage: 0.42),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: minPrice,
                        decoration: InputDecoration(
                          hintText: 'Min Price (SR)'.tr(),
                          hintStyle: const TextStyle(fontSize: 14),
                          prefixIcon: Image.asset("assets/icons/receipt.png"),
                          fillColor: kTextFiledGrayColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kTextFiledGrayColor),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: screenWidthPercentage(context, percentage: 0.42),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        controller: maxPrice,
                        decoration: InputDecoration(
                          hintText: 'Max Price (SR)'.tr(),
                          hintStyle: const TextStyle(fontSize: 14),
                          fillColor: kTextFiledGrayColor,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: kTextFiledGrayColor),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                verticalSpaceRegular,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: screenWidthPercentage(context, percentage: 0.72),
                      decoration: BoxDecoration(
                        color: kTextFiledGrayColor,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Row(
                        children: [
                          horizontalSpaceSmall,
                          horizontalSpaceTiny,
                          Image.asset("assets/icons/navbar/experience.png"),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: ButtonTheme(
                                alignedDropdown: true,
                                child: DropdownButton<String>(
                                  value: model.category,
                                  iconSize: 24,
                                  icon: (null),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                  onChanged: (value) => model.updateCategory(
                                      value: value ?? "All categories"),
                                  items: model
                                      .categoriesWithNone()
                                      .map((c) => DropdownMenuItem(
                                            value: c,
                                            onTap: () {},
                                            child: SizedBox(
                                              child: Text(
                                                c.tr(),
                                                style: const TextStyle(
                                                    fontFamily: 'Cairo'),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 55,
                      height: 55,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        gradient: kMainGradient,
                      ),
                      child: Center(
                        child: Image.asset("assets/icons/navbar/search.png",
                            color: Colors.white),
                      ),
                    ).gestures(
                        onTap: () => filterExperiences(model.genderConstraint,
                            model.from, model.to, model.city, model.category)),
                  ],
                ),
                verticalSpaceLarge,
                filteredExperiences.value.isEmpty
                    ? const SizedBox()
                    : model.isBusy
                        ? const Loader().center()
                        : Text(
                            'Your results'.tr(),
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                filteredExperiences.value.isEmpty
                    ? const SizedBox()
                    : verticalSpaceMedium,
                filteredExperiences.value.isEmpty
                    ? const SizedBox()
                    : model.isBusy
                        ? const SizedBox()
                        : filteredExperiences.value.isEmpty
                            ? const Text(
                                    'No results found with this specifications')
                                .center()
                            : SizedBox(
                                height: 255,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 2),
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: filteredExperiences.value.length,
                                  itemBuilder: (context, index) {
                                    return CreationAwareListItem(
                                      itemCreated: () => model
                                          .getPublicExperiencesFromNextPage(
                                              index: index + 1),
                                      child: Container(
                                        height: 250,
                                        width: 200,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 1,
                                              offset: Offset(0, 0),
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 200,
                                              height: 150,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                  fit: filteredExperiences
                                                              .value[index]
                                                              .profileImage !=
                                                          null
                                                      ? filteredExperiences
                                                              .value[index]
                                                              .profileImage!
                                                              .contains(
                                                                  '/asbar-icon.ico')
                                                          ? BoxFit.none
                                                          : BoxFit.cover
                                                      : BoxFit.contain,
                                                  image: filteredExperiences
                                                                  .value[index]
                                                                  .profileImage !=
                                                              null &&
                                                          filteredExperiences
                                                              .value[index]
                                                              .profileImage!
                                                              .contains(
                                                                  '/asbar-icon.ico')
                                                      ? NetworkImage(
                                                              "$baseUrl${filteredExperiences.value[index].profileImage}")
                                                          as ImageProvider
                                                      : const AssetImage(
                                                          "assets/images/image4.png"),
                                                ),
                                              ),
                                            ).center(),
                                            verticalSpaceSmall,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                SizedBox(
                                                  width: 120,
                                                  child: Text(
                                                      filteredExperiences
                                                          .value[index].title!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(filteredExperiences
                                                        .value[index].rate!),
                                                    horizontalSpaceTiny,
                                                    const Icon(
                                                      Icons.star,
                                                      color: kStarColor,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ).padding(horizontal: 8),
                                            verticalSpaceSmall,
                                            Row(
                                              children: [
                                                Image.asset(
                                                    "assets/icons/location.png"),
                                                horizontalSpaceTiny,
                                                SizedBox(
                                                  width: 160,
                                                  child: Text(
                                                    "${filteredExperiences.value[index].city}${filteredExperiences.value[index].city}, ${filteredExperiences.value[index].duration!} ${double.parse(filteredExperiences.value[index].duration!) >= 2 ? 'Hours'.tr() : 'Hour'.tr()}",
                                                    style: const TextStyle(
                                                        color: kMainGray,
                                                        fontSize: 11),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ).padding(horizontal: 8),
                                            verticalSpaceSmall,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                        '${filteredExperiences.value[index].price!} ${"SR".tr()}',
                                                        style: const TextStyle(
                                                            color: kMainColor1,
                                                            fontSize: 9)),
                                                    Text(' / Person'.tr(),
                                                        style: const TextStyle(
                                                            color: kMainGray,
                                                            fontSize: 9)),
                                                  ],
                                                ),
                                                Container(
                                                  width: 70,
                                                  height: 25,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(8)),
                                                    gradient: kMainGradient,
                                                  ),
                                                  child: Text(
                                                    'Book Now'.tr(),
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ).center(),
                                                ).gestures(onTap: () {
                                                  model.navigateTo(
                                                      view: user == null
                                                          ? const LoginView()
                                                          : ConfirmBookingView(
                                                              experience:
                                                                  filteredExperiences
                                                                          .value[
                                                                      index],
                                                              user: user,
                                                            ));
                                                }),
                                              ],
                                            ).padding(horizontal: 8),
                                          ],
                                        ),
                                      ).gestures(
                                        onTap: () => model.navigateTo(
                                            view: TripDetailView(
                                                isUser: isUser,
                                                experience: filteredExperiences
                                                    .value[index],
                                                user: user)),
                                      ),
                                    );
                                  },
                                ),
                              ),
              ],
            ),
          ),
        )),
      ),
      viewModelBuilder: () => SearchViewModel(context: context),
    );
  }
}
