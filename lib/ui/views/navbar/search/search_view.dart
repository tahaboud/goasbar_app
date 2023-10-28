import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
import 'package:motion_toast/resources/arrays.dart';
import 'package:stacked/stacked.dart';
import 'package:styled_widget/styled_widget.dart';

class SearchView extends HookWidget {
  const SearchView({Key? key, this.isUser, this.user}) : super(key: key);
  final UserModel? user;
  final bool? isUser;

  @override
  Widget build(BuildContext context) {
    var minPrice = useTextEditingController();
    var maxPrice = useTextEditingController();
    var title = useTextEditingController();

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
                              onChanged: (value) =>
                                  model.updateCity(value: value),
                              items: model
                                  .citiesWithNone()
                                  .map((c) => DropdownMenuItem(
                                        value: c == 'Search by Region'.tr()
                                            ? c
                                            : "${c[0]}${c.substring(1).replaceAll('_', ' ').toLowerCase()}",
                                        onTap: () {},
                                        child: SizedBox(
                                          child: Text(
                                            c == 'Search by Region'.tr()
                                                ? c
                                                : "${c[0]}${c.substring(1).replaceAll('_', ' ').toLowerCase()}",
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
                    suffixIcon: const Icon(Icons.clear).gestures(
                      onTap: () => model.clearSearchDate(),
                    ),
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
                                  model.updateGenderConstraint(value: value),
                              items: genderConstraints
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        onTap: () {},
                                        child: SizedBox(
                                          child: Text(
                                            c,
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
                                  onChanged: (value) =>
                                      model.updateCategory(value: value),
                                  items: model
                                      .categoriesWithNone()
                                      .map((c) => DropdownMenuItem(
                                            value: c ==
                                                    'Experience Category'.tr()
                                                ? c
                                                : "${c[0]}${c.substring(1).replaceAll('_', ' ').toLowerCase()}",
                                            onTap: () {},
                                            child: SizedBox(
                                              child: Text(
                                                c == 'Experience Category'.tr()
                                                    ? c
                                                    : "${c[0]}${c.substring(1).replaceAll('_', ' ').toLowerCase()}",
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
                    ).gestures(onTap: () {
                      String query = '';

                      if (model.genderConstraint == "No constrains".tr()) {
                        query = '$query&gender=None';
                      }
                      if (model.genderConstraint == "Families only".tr()) {
                        query = '$query&gender=FAMILIES';
                      }
                      if (model.genderConstraint == "Men Only".tr()) {
                        query = '$query&gender=MEN';
                      }
                      if (model.genderConstraint == "Women Only".tr()) {
                        query = '$query&gender=WOMEN';
                      }

                      if (model.from != '') {
                        query = '$query&date_min=${model.from}';
                      }
                      if (model.to != '') query = '$query&date_max=${model.to}';

                      if (model.city != 'Search by Region'.tr()) {
                        query =
                            '$query&city=${model.city!.replaceAll(' ', '_').toUpperCase()}';
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

                      if (model.category != 'Experience Category'.tr()) {
                        query = '$query&category=${model.category}';
                      }

                      if (query != '') {
                        model
                            .getPublicExperiences(
                          query: query.replaceFirst(r'&', '?'),
                        )
                            .then((value) {
                          if (value != null) {
                          } else {
                            showMotionToast(
                                context: context,
                                title: 'No experience found',
                                msg:
                                    "No experience found with your specifications",
                                type: MotionToastType.warning);
                          }
                        });
                      }
                    }),
                  ],
                ),
                verticalSpaceLarge,
                model.experienceModels == null
                    ? const SizedBox()
                    : model.isBusy
                        ? const Loader().center()
                        : Text(
                            'Your results'.tr(),
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                model.experienceModels == null
                    ? const SizedBox()
                    : verticalSpaceMedium,
                model.experienceModels == null
                    ? const SizedBox()
                    : model.isBusy
                        ? const SizedBox()
                        : model.experienceModels!.count == 0
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
                                  itemCount: model.experienceModels!.count,
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
                                                  fit: model
                                                              .experienceModels!
                                                              .results![index]
                                                              .profileImage !=
                                                          null
                                                      ? model
                                                              .experienceModels!
                                                              .results![index]
                                                              .profileImage!
                                                              .contains(
                                                                  '/asbar-icon.ico')
                                                          ? BoxFit.none
                                                          : BoxFit.cover
                                                      : BoxFit.contain,
                                                  image: model
                                                                  .experienceModels!
                                                                  .results![
                                                                      index]
                                                                  .profileImage !=
                                                              null &&
                                                          !model
                                                              .experienceModels!
                                                              .results![index]
                                                              .profileImage!
                                                              .contains(
                                                                  '/asbar-icon.ico')
                                                      ? NetworkImage(
                                                              "$baseUrl${model.experienceModels!.results![index].profileImage}")
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
                                                      model
                                                          .experienceModels!
                                                          .results![index]
                                                          .title!,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(model.experienceModels!
                                                        .results![index].rate!),
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
                                                    "${model.experienceModels!.results![index].city![0]}${model.experienceModels!.results![index].city!.substring(1).replaceAll('_', ' ').toLowerCase()}, ${model.experienceModels!.results![index].duration!} ${double.parse(model.experienceModels!.results![index].duration!) >= 2 ? 'Hours'.tr() : 'Hour'.tr()}",
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
                                                        '${model.experienceModels!.results![index].price!} ${"SR".tr()}',
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
                                                              experience: model
                                                                  .experienceModels!
                                                                  .results![index],
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
                                                experience: model
                                                    .experienceModels!
                                                    .results![index],
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
