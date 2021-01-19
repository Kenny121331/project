import 'package:flutter_app_parkinglots/app/forgotPassword/forgot.dart';
import 'package:flutter_app_parkinglots/app/home/bill/bill.dart';
import 'package:flutter_app_parkinglots/app/home/bill/billDetails.dart';
import 'package:flutter_app_parkinglots/app/home/home.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/detailsPL.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/fiveNearestPL.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/rent/MyRentStates.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/rent/rentStateDetails.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/reservation/reservationDetails.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/reservation/stateReservation.dart';
import 'package:flutter_app_parkinglots/app/home/parkingLots/statePL/statePL_view.dart';
import 'package:flutter_app_parkinglots/app/home/splash.dart';
import 'package:flutter_app_parkinglots/app/home/userInformation/information.dart';
import 'package:flutter_app_parkinglots/app/login/login.dart';
import 'package:flutter_app_parkinglots/app/register/register.dart';
import 'package:flutter_app_parkinglots/app/routers/App_routes.dart';
import 'package:get/get.dart';

class AppPages {
  static const INITIAL = Routers.LOGIN;
  static final routes = [
    GetPage(
        name: Routers.HOME,
        page: () => Home()
    ),
    GetPage(
        name: Routers.LOGIN,
        page: () => Login()
    ),
    GetPage(
        name: Routers.REGISTER,
        page: () => Register()
    ),
    GetPage(
        name: Routers.FORGETPASSWORD,
        page: () => GetPassword()
    ),
    GetPage(
        name: Routers.MYRENTSTATES,
        page: () => MyRentStates()
    ),
    GetPage(
        name: Routers.FIVENEARSTPL,
        page: () => FiveNearstPL()
    ),
    GetPage(
        name: Routers.RESERVATIONDETAILS,
        page: () => ReservationDetails()
    ),
    GetPage(
        name: Routers.RESERVATION,
        page: () => MyReservations()
    ),
    GetPage(
        name: Routers.BILLDETAILS,
        page: () => BillDetails()
    ),
    GetPage(
        name: Routers.MYRENTSTATESDETAILS,
        page: () => RentStateDetails()
    ),
    GetPage(
        name: Routers.MYBILLS,
        page: () => MyBills()
    ),
    GetPage(
        name: Routers.BILLDETAILS,
        page: () => BillDetails()
    ),
    GetPage(
        name: Routers.INFORMATION,
        page: () => Information()
    ),
    GetPage(
        name: Routers.DETAILSPL,
        page: () => DetailsPL()
    ),
    GetPage(
        name: Routers.SPLASHSCREEN,
        page: () => SplashScreen()
    ),
    GetPage(
        name: Routers.STATEPL,
        page: () => StatePL()
    ),
  ];
}
