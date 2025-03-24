<template>
  <div class="login-container">
    <div class="login-box">
      <h2 class="login-title">Administrator Login</h2>
      <form @submit.prevent="handleLogin" class="login-form">
        <div class="form-group">
          <label for="username">Username</label>
          <input
            type="text"
            id="username"
            v-model="credentials.username"
            required
            placeholder="Enter username"
            class="form-input"
          />
        </div>
        <div class="form-group">
          <label for="password">Password</label>
          <input
            type="password"
            id="password"
            v-model="credentials.password"
            required
            placeholder="Enter password"
            class="form-input"
          />
        </div>
        <div v-if="error" class="error-message">
          {{ error }}
        </div>
        <button type="submit" class="login-button" :disabled="isLoading">
          <span class="button-text">{{ isLoading ? 'Logging in...' : 'Login' }}</span>
        </button>
      </form>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'LoginPage',
  data() {
    return {
      credentials: {
        username: '',
        password: ''
      },
      error: '',
      isLoading: false
    };
  },
  methods: {
    async handleLogin() {
      this.isLoading = true;
      this.error = '';
      
      try {
        const response = await axios.post('http://localhost:5000/login', this.credentials);
        if (response.data.success) {
          localStorage.setItem('adminToken', response.data.token);
          this.$emit('login-success');
        }
      } catch (error) {
        this.error = error.response?.data?.error || 'Login failed. Please try again.';
      } finally {
        this.isLoading = false;
      }
    }
  }
};
</script>

<style scoped>
.login-container {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  padding: 20px;
}

.login-box {
  width: 100%;
  max-width: 400px;
  padding: 40px;
  background-color: white;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.login-title {
  text-align: center;
  margin-bottom: 30px;
  color: #2c3e50;
  font-size: 1.8em;
  font-weight: 600;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.form-group label {
  font-size: 0.9em;
  color: #4a5568;
  font-weight: 500;
}

.form-input {
  padding: 12px 16px;
  font-size: 1em;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  transition: all 0.3s ease;
}

.form-input:focus {
  border-color: #4299e1;
  box-shadow: 0 0 0 3px rgba(66, 153, 225, 0.2);
  outline: none;
}

.login-button {
  width: 100%;
  padding: 14px;
  background-color: #4299e1;
  color: white;
  font-size: 1em;
  font-weight: 600;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
  margin-top: 10px;
}

.login-button:hover:not(:disabled) {
  background-color: #3182ce;
  transform: translateY(-1px);
}

.login-button:disabled {
  background-color: #cbd5e0;
  cursor: not-allowed;
}

.error-message {
  color: #e53e3e;
  font-size: 0.9em;
  text-align: center;
  padding: 8px;
  background-color: #fff5f5;
  border-radius: 4px;
}

.button-text {
  display: inline-block;
  transition: transform 0.3s ease;
}

.login-button:hover .button-text:not(:disabled) {
  transform: translateY(-1px);
}
</style> 