const baseUrl = "https://fitness-app-e0xl.onrender.com";

class FoodDiariesApi {
  static const fooddiaries = "/fooddiaries";
}

class NutritionsApi {
  static const nutritionById = "/nutritions/{id}";
  static const dailynutritionById = "/dailynutrition/{id}";
  static const dailynutritionTotalById =
      "/dailynutrition/{id}/total?start_date={startDate}&end_date={endDate}&get_type={type}";
}

class NotificationsApi {
  static const getUnreadNotification = "/notifications/{id}/unread-count";
  static const resetUnreadNotification =
      "/notifications/{id}/reset-unread-count";
  static const filterNotifications =
      "/notifications/{id}?page={page}&per_page=10";
}

class NewsfeedApi {
  static const newsfeed = "/newsfeeds";
  static const searchLocation = "/locations?q={location}";
}
