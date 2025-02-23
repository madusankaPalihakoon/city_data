import React, { useState } from "react";
import { View, Text, TextInput, TouchableOpacity } from "react-native";
import tw from "tailwind-react-native-classnames";
import { apiRequest } from "../services/api";

const app = () => {
  const [formData, setFormData] = useState({ username: "", password: "" });

  const handleChange = (name, value) => {
    setFormData({ ...formData, [name]: value });
  };

  const handleSubmit = () => {
    console.log("Login Data:", formData);
    apiRequest("POST", "/user/login/", formData)
      .then((response) => {
        console.log("Login Response:", response);
      })
      .catch((error) => {
        console.log("Login Error:", error);
      });
  };

  return (
    <View style={tw`flex-1 justify-center items-center bg-white`}>
      <View style={tw`w-11/12 max-w-md p-6`}>
        <Text style={tw`text-2xl font-semibold text-center text-gray-800 mb-6`}>
          Login
        </Text>

        <View style={tw`mb-4`}>
          <Text style={tw`text-gray-700`}>Username</Text>
          <TextInput
            value={formData.username}
            onChangeText={(value) => handleChange("username", value)}
            style={tw`w-full px-4 py-2 bg-gray-200 rounded-md mt-1`}
            placeholder="Enter your username"
          />
        </View>

        <View style={tw`mb-4`}>
          <Text style={tw`text-gray-700`}>Password</Text>
          <TextInput
            value={formData.password}
            onChangeText={(value) => handleChange("password", value)}
            secureTextEntry
            style={tw`w-full px-4 py-2 bg-gray-200 rounded-md mt-1`}
            placeholder="Enter your password"
          />
        </View>

        <TouchableOpacity
          onPress={handleSubmit}
          style={tw`w-full bg-blue-500 py-2 rounded-md items-center mt-4`}
        >
          <Text style={tw`text-white text-lg`}>Login</Text>
        </TouchableOpacity>

        <View style={tw`items-center mt-4`}>
          <TouchableOpacity>
            <Text style={tw`text-blue-500`}>Create Account</Text>
          </TouchableOpacity>
        </View>
      </View>
    </View>
  );
};

export default app;
