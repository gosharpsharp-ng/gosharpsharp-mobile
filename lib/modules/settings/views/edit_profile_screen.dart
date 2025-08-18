import 'package:gosharpsharp/core/utils/exports.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settingsController) {
      return Form(
        key: settingsController.profileUpdateFormKey,
        child: Scaffold(
          appBar: defaultAppBar(
            implyLeading: true,
            bgColor: AppColors.backgroundColor,
            title: "Edit Profile",
            centerTitle: false,

          ),
          body: Container(
            height: 1.sh,
            width: 1.sw,
            color: AppColors.backgroundColor,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SectionBox(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    backgroundColor: AppColors.whiteColor,
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      Stack(
                        alignment:
                            Alignment.center, // Aligns content within the stack
                        children: [
                          Visibility(
                            visible:
                                settingsController.userProfile?.avatar != null,
                            replacement: Visibility(
                              visible:
                                  settingsController.userProfilePicture != null,
                              replacement: CircleAvatar(
                                radius: 55.r,
                                backgroundColor: AppColors.backgroundColor,
                                child: customText(
                                  "${settingsController.userProfile?.fname.substring(0, 1) ?? ""}${settingsController.userProfile?.lname.substring(0, 1) ?? ""}",
                                  fontSize: 24.sp,
                                ),
                              ),
                              child:
                                  settingsController.userProfilePicture != null
                                      ? CircleAvatar(
                                          backgroundImage: FileImage(
                                              settingsController
                                                  .userProfilePicture!),
                                          radius: 55.r,
                                        )
                                      : CircleAvatar(
                                          backgroundImage: const AssetImage(
                                              PngAssets.avatarIcon),
                                          radius: 55.r,
                                        ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  settingsController.userProfile!.avatar ?? ''),
                              radius: 55.r,
                            ),
                          ),
                          // Add the edit/camera icon
                          Positioned(
                            bottom: 3,
                            right: 5,
                            child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(25.0),
                                      ),
                                    ),
                                    builder: (BuildContext context) {
                                      return CustomImagePickerBottomSheet(
                                        title: "Change Profile Photo",
                                        takePhotoFunction: () {
                                          settingsController.pickUserProfilePicture(
                                              pickFromCamera: true);
                                        },
                                        selectFromGalleryFunction: () {
                                          settingsController.pickUserProfilePicture(
                                              pickFromCamera: false);
                                        },
                                        deleteFunction: () {},
                                      );
                                    });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.backgroundColor,
                                  shape: BoxShape.circle,
                                ),

                                padding: EdgeInsets.all(8.sp),
                                child: settingsController.isUpdatingAvatar?SizedBox(
                                  height: 20.sp,width: 20.sp,
                                  child: CircularProgressIndicator(color: AppColors.primaryColor,strokeWidth: 1.2.sp,),
                                ):Icon(
                                  Icons.edit, // or Icons.camera_alt
                                  size: 20.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 15.h,
                      ),
                      CustomRoundedInputField(
                        title: "First name",
                        label: "John",
                        // readOnly: !settingsController.isProfileEditable,
                        showLabel: true,
                        hasTitle: true,
                        controller: settingsController.fNameController,
                      ),
                      CustomRoundedInputField(
                        title: "Last name",
                        label: "Does",
                        showLabel: true,
                        // readOnly: !settingsController.isProfileEditable,
                        hasTitle: true,
                        controller: settingsController.lNameController,
                      ),
                      CustomRoundedInputField(
                        title: "Email",
                        label: "johndoe@gmail.com",
                        showLabel: true,
                        hasTitle: true,
                        readOnly: true,
                        controller: settingsController.emailController,
                        // controller: signInProvider.emailController,
                      ),
                      CustomRoundedInputField(
                        title: "Phone number",
                        label: "7061046672",
                        showLabel: true,
                        hasTitle: true,
                        readOnly: true,
                        controller: settingsController.phoneController,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 20.sp),
                    child: CustomButton(
                      onPressed: () {
                        settingsController.updateUserProfile();
                      },
                      isBusy: settingsController.isLoading,
                      title: "Save",
                      width: 1.sw,
                      backgroundColor: AppColors.primaryColor,
                      fontColor: AppColors.whiteColor,
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
