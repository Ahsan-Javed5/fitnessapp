# fitnessapp

A flutter project for Fitness Application
## flutter packages pub run build_runner build
## flutter packages pub run build_runner build --delete-conflicting-outputs
################################## Being Authored By Awais Abbas ##################################

## BLoC Architecture for flutter applications
- https://dzone.com/articles/how-to-develop-your-flutter-app-with-the-bloc-arch

## Flutter App Structure
- https://www.geeksforgeeks.org/flutter-file-structure/

## Sample project which show off different flutter architectures
- https://github.com/brianegan/flutter_architecture_samples

## Medium helpful article on GetX
- https://medium.com/flutter-community/the-flutter-getx-ecosystem-state-management-881c7235511d

## Flutter form builder and validator
- https://pub.dev/packages/flutter_form_builder/install

## Hive is a lightweight and blazing fast key-value database written in pure Dart. Inspired by Bitcask.
- https://pub.dev/packages/hive

## For Android Signing Report
- cd android
  ./gradlew signingReport


##-------------------------------------------- Navigation using GetX-------------------------------------------------##
## In GetX method :
- Get.to(Second());

## If we can navigate screen into another page and delete current page from stack then we can use method which is define below :
- Get.off(Third());

## If we can navigate screen into another page and delete all route or page from stack then we can use the method which is define below :
- Get.offAll(Third());
## If we want to use Navigator.pop() then GetX give a Method which is define below :
- Get.back();

## If we want to pass data through the navigator then we use below method :
## for passing single argument
- Get.to(Second(),arguments:"Hello World!");

## for passing multiple argument
- Get.to(Second(),arguments:[10,20]);

## If we want to pass argument with return navigator like Navigator.pop() method we can use result: property of this method as per below example.
- Get.back(result: "Hello world");