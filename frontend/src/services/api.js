import axios from "axios";

const API_BASE_URL = "https://api.example.com";

export const login = async (email, password) => {
    const response = await axios.post(`${API_BASE_URL}/login`, {
        email,
        password,
    });
    return response.data;
};
