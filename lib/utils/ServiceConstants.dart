class ServiceConstants {

  static String BASE_URL = 'https://ibevent-api.testlinks.co.za/api/';
  static String AUTH_TOKEN = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpYXQiOjE1NzEwMzEwNjcsImV4cCI6MTU3MTQ2MzA2Nywicm9sZXMiOlsiUk9MRV9VU0VSIl0sInVzZXJuYW1lIjoid2p2aWxqb2VuQGdtYWlsLmNvbSJ9.e_00k2xWDuZp3SW_F6AtTaqwNxMEammPfOiIiFLoyH-BsAkQGB7Ct9ugDCSYuAGn5F_x_DFJGTvwwnM797MCyen6I1Z_POrBKYwmc1fAirEUbGk-ZywNADEbBMAnRJNdO4isx71RXtmfn3nuhBuZWECMgWBZXexcWQ2jQQBkbHKWYakfFgsYrXnjT-7c5PDk9gIHpjhPkNhOCTZJcUgjPeTliQrtA3037VbGTNxVC5i4bmLuUHyICPMEkHqCleTaTS9nqszWvNinYNgmkJbPVvQy2UhiWI8_s6PXhDhlEBt0tbT5MI8FefyQKvHwBcNzGKYBkRZG4BKuCEyIvC7eD6JLNzrOojZR-W96quSN0KydXJ2pP84DTle3kkLvcyOxwkVEEK7zREkgRCoswPsfoz6Iv2wNlAmuMR_Zooh3nJ6asNVv8qAeX-_noIXciJuc6Md2Q1LOKfLl4YOpvvy6xINbnXSSkpDN_WhJ0jA4PKbyVzAxEMb7-pQWdZ60PqiUaQeHduiH5Q_vgDMDKfQqcZceJ-75GTtLIfdSG9UP3e48zKv9ZG35lieW3aoiNVEOQRAghpJy4dinZ6-i0H1C_VdpT8ziD6fLcTJ_YZK99GJ83v7tNp42CWSDuevQ-dror8DCckoBQ0Z4SLpMfCcuahpSTHCRN6RVJjrzT0io26c';

  static String AUTHENTICATION_TOKEN = BASE_URL + 'authentication_token';

  static String GET_ALL_PROGRAMS = BASE_URL + 'program/activitylist';
  static String GET_PROGRAMS_BY_ID = BASE_URL + 'program/activity/';

  static String GET_ALL_EXHIBITORS = BASE_URL + 'exhibitorlist';
  static String GET_EXHIBITOR_MAP_DETAIL = BASE_URL + 'exhibitor/';

  static String GET_ALL_INNOVATIONS = BASE_URL + 'innovationlist';
  static String GET_INNOVATION_MAP_DETAIL = BASE_URL + 'innovation/';

  static String GET_ALL_ATTENDEES = BASE_URL + 'attendeelist';

  static String GET_ALL_SPEED_SESSIONS = BASE_URL + 'speed_networking/session_list';

  static String GET_ALL_BOOKMARKS = BASE_URL + 'my_bookmarks';
  static String GET_BOOKMARK_BY_ID = BASE_URL + "my_bookmarks/?id=";

  static String GET_ALL_ANNOUNCEMENTS = BASE_URL + 'announcements';
  static String GET_ANNOUCEMENT_COUNT = BASE_URL + 'announcements_count';

  static String BOOKMARK_ADD = BASE_URL + 'bookmark/add';
  static String BOOKMARK_EDIT_DELETE = BASE_URL + 'bookmark/edit';

  static String GET_EVENT_SCHEDULE = BASE_URL + 'meetings/meetinglist';

  static String MEETING_ATTEND_DECLINE = BASE_URL + "meeting/";

  static String GET_EVENT_DETAILS = BASE_URL + 'eventdetail';
}