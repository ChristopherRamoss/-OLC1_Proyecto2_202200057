import axios from 'axios';

const API_BASE_URL = 'http://localhost:3000'; 

export const parserService = {
  parseCode: async (code) => {
    try {
      const response = await axios.post(`${API_BASE_URL}/parse`, {
        code: code
      });
      return response.data;
    } catch (error) {
      throw new Error(error.response?.data?.message || 'Error al procesar el código');
    }
  }
};