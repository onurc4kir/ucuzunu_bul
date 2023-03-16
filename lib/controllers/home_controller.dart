import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ucuzunu_bul/views/home_tabs/home_tab.dart';
import 'package:ucuzunu_bul/views/home_tabs/profile_tab.dart';
import 'package:ucuzunu_bul/views/home_tabs/rewards_tab.dart';
import 'package:ucuzunu_bul/views/home_tabs/search_tab.dart';

enum HomePageTabs { home, rewards, search, profile }

class HomeController extends GetxController {
  final tabs = <HomePageTabs, Widget>{
    HomePageTabs.home: const HomeTab(),
    HomePageTabs.rewards: const RewardsTab(),
    HomePageTabs.search: const SearchTab(),
    HomePageTabs.profile: const ProfileTab()
  };

  final Rx<HomePageTabs> _selectedTab = HomePageTabs.home.obs;
  HomePageTabs get selectedTab => _selectedTab.value;

  changeTab(HomePageTabs tab) {
    _selectedTab.value = tab;
  }
}
