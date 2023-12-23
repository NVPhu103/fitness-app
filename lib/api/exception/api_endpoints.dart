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
