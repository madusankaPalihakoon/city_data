import axios from "axios";

// Base URL for API requests
const API_BASE_URL = "https://vertextback.geoinfobox.com/api";

// Create an Axios instance
const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 10000, // Set a timeout
  headers: {
    "Content-Type": "application/json",
  },
});

// Function to set Authorization token dynamically
export const setAuthToken = (token) => {
  if (token) {
    apiClient.defaults.headers.common["Authorization"] = `Bearer ${token}`;
  } else {
    delete apiClient.defaults.headers.common["Authorization"];
  }
};

// API Request Function
export const apiRequest = async (method, url, data = {}, params = {}) => {
  try {
    const response = await apiClient({
      method,
      url,
      data,
      params,
    });
    return response.data; // Return response data
  } catch (error) {
    console.error("API Error:", error?.response?.data || error.message);
    throw error.response?.data || error.message;
  }
};
