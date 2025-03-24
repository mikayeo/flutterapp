<template>
  <div>
    <div v-if="!isAuthenticated">
      <Login @login-success="handleLoginSuccess" />
    </div>
    <div v-else class="page-container">
      <div class="student-form-container">
        <div class="form-wrapper">
          <div class="header">
            <h2 class="form-title">Student Registration</h2>
            <button @click="handleLogout" class="logout-button">
              Logout
            </button>
          </div>
          <form @submit.prevent="handleSubmit" class="registration-form">
            <div class="form-row">
              <div class="form-group">
                <label for="id">Student ID</label>
                <input
                  type="text"
                  id="id"
                  v-model="student.id"
                  required
                  placeholder="Enter student ID"
                  class="form-input"
                />
              </div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label for="firstname">First Name</label>
                <input
                  type="text"
                  id="firstname"
                  v-model="student.firstname"
                  required
                  placeholder="Enter first name"
                  class="form-input"
                />
              </div>

              <div class="form-group">
                <label for="lastname">Last Name</label>
                <input
                  type="text"
                  id="lastname"
                  v-model="student.lastname"
                  required
                  placeholder="Enter last name"
                  class="form-input"
                />
              </div>
            </div>

            <div class="form-row">
              <div class="form-group">
                <label for="email">Email</label>
                <input
                  type="email"
                  id="email"
                  v-model="student.email"
                  required
                  placeholder="Enter email"
                  class="form-input"
                />
              </div>

              <div class="form-group">
                <label for="major">Major</label>
                <input
                  type="text"
                  id="major"
                  v-model="student.major"
                  required
                  placeholder="Enter major"
                  class="form-input"
                />
              </div>
            </div>

            <div class="form-group photo-upload">
              <label for="photo">Photo</label>
              <div class="file-input-container">
                <input
                  type="file"
                  id="photo"
                  @change="handleFileUpload"
                  accept="image/*"
                  required
                  class="file-input"
                  :disabled="isUploading"
                />
                <label for="photo" class="file-input-label" :class="{ 'uploading': isUploading }">
                  <span class="upload-icon">📷</span>
                  {{ isUploading ? 'Uploading...' : 'Choose Photo' }}
                </label>
              </div>
              <transition name="fade">
                <div v-if="student.photoUrl" class="preview">
                  <img :src="student.photoUrl" alt="Preview" />
                </div>
              </transition>
            </div>

            <button type="submit" :disabled="!valid" class="submit-button">
              <span class="button-text">Submit Registration</span>
            </button>
          </form>
        </div>
      </div>

      <!-- Students List Section -->
      <div class="students-list-container">
        <div class="students-wrapper">
          <h2 class="section-title">Registered Students</h2>
          <div class="students-grid">
            <div v-for="student in students" :key="student.id" class="student-card">
              <div class="student-photo">
                <img 
                  :src="student.photoUrl" 
                  :alt="student.firstname + ' ' + student.lastname"
                  @error="handleImageError"
                />
              </div>
              <div class="student-info">
                <h3>{{ student.firstname }} {{ student.lastname }}</h3>
                <p><strong>ID:</strong> {{ student.id }}</p>
                <p><strong>Email:</strong> {{ student.email }}</p>
                <p><strong>Major:</strong> {{ student.major }}</p>
                <div class="qr-code-container">
                  <QRCode 
                    :id="'qr-' + student.id"
                    :value="generateStudentData(student)"
                    :size="256"
                    level="H"
                    render-as="svg"
                    :margin="4"
                    class="qr-code"
                    color="#000000"
                    background="#ffffff"
                  />
                  <p class="qr-label">Scan for Student ID</p>
                  <button 
                    @click="downloadQRCode(student)" 
                    class="download-button"
                  >
                    Download QR Code
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import Login from './components/Login.vue';
import QRCode from 'qrcode.vue';

export default {
  name: "StudentForm",
  components: {
    Login,
    QRCode
  },
  data() {
    return {
      isAuthenticated: false,
      students: [],
      student: {
        id: "",
        firstname: "",
        lastname: "",
        email: "",
        major: "",
        photoUrl: "",
      },
      photo: null,
      valid: true,
      isUploading: false,
    };
  },
  created() {
    // Clear any existing token
    localStorage.removeItem('adminToken');
    
    // Check if user is already logged in
    const token = localStorage.getItem('adminToken');
    if (token) {
      // Verify token with backend
      axios.get('http://localhost:5000/verify-token', {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })
      .then(response => {
        if (response.data.valid) {
          this.isAuthenticated = true;
          this.fetchStudents();
        } else {
          this.handleLogout();
        }
      })
      .catch(() => {
        this.handleLogout();
      });
    }
  },
  methods: {
    handleLoginSuccess() {
      console.log('Login successful');
      this.isAuthenticated = true;
      this.fetchStudents();
    },
    handleLogout() {
      console.log('Logging out');
      localStorage.removeItem('adminToken');
      this.isAuthenticated = false;
      this.students = [];
    },
    fetchStudents() {
      const token = localStorage.getItem('adminToken');
      axios.get("http://localhost:5000/students", {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      })
      .then(response => {
        console.log('Fetched students:', response.data);
        this.students = response.data;
      })
      .catch(error => {
        console.error("Error fetching students:", error);
        if (error.response?.status === 401) {
          this.handleLogout();
        } else {
          alert("Error loading students list.");
        }
      });
    },
    handleSubmit() {
      const token = localStorage.getItem('adminToken');
      const studentData = {
        id: this.student.id,
        firstname: this.student.firstname,
        lastname: this.student.lastname,
        email: this.student.email,
        major: this.student.major,
        photoUrl: this.student.photoUrl
      };

      axios
        .post("http://localhost:5000/submit", studentData, {
          headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${token}`
          },
        })
        .then(() => {
          this.resetForm();
          this.fetchStudents(); // Refresh the students list
          alert("Student added successfully!");
        })
        .catch((error) => {
          console.error("Error submitting form:", error);
          if (error.response?.status === 401) {
            this.handleLogout();
          } else {
            alert("Error submitting the form.");
          }
        });
    },

    handleFileUpload(event) {
      this.photo = event.target.files[0];
      if (this.photo) {
        this.uploadToImgBB(this.photo);
      }
    },

    uploadToImgBB(file) {
      this.isUploading = true;
      const formData = new FormData();
      formData.append('image', file);
      
      axios.post(`https://api.imgbb.com/1/upload?key=26056e1b8938b47abc62a7e99e716f27`, formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      })
      .then(response => {
        if (response.data.success) {
          this.student.photoUrl = response.data.data.url;
          console.log('Image uploaded successfully:', this.student.photoUrl);
        } else {
          console.error('Failed to upload image:', response.data.error);
          alert('Failed to upload image. Please try again.');
        }
      })
      .catch(error => {
        console.error('Error uploading image:', error);
        alert('Error uploading image. Please try again.');
      })
      .finally(() => {
        this.isUploading = false;
      });
    },

    resetForm() {
      this.student.id = "";
      this.student.firstname = "";
      this.student.lastname = "";
      this.student.email = "";
      this.student.major = "";
      this.photo = null;
      this.student.photoUrl = "";
    },

    handleImageError(e) {
      console.error('Image failed to load:', e.target.src);
      e.target.src = 'https://via.placeholder.com/300x200?text=No+Image';
    },

    generateStudentData(student) {
      // Return just the student ID as plain text
      return `Student ID: ${student.id}`;
    },

    downloadQRCode(student) {
      const qrContainer = document.querySelector(`#qr-${student.id}`);
      if (!qrContainer) return;
      
      const svg = qrContainer.querySelector('svg');
      if (!svg) return;

      const svgData = new XMLSerializer().serializeToString(svg);
      const canvas = document.createElement('canvas');
      const ctx = canvas.getContext('2d');
      const img = new Image();
      
      img.onload = () => {
        canvas.width = 256;
        canvas.height = 256;
        
        // Fill white background
        ctx.fillStyle = '#ffffff';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        
        // Draw QR code
        ctx.drawImage(img, 0, 0);
        
        // Add student ID text at bottom
        ctx.fillStyle = '#000000';
        ctx.font = 'bold 16px Arial';
        ctx.textAlign = 'center';
        ctx.fillText(student.id, canvas.width/2, canvas.height - 20);
        
        // Convert to PNG and download
        const a = document.createElement('a');
        a.download = `student-${student.id}-qr.png`;
        a.href = canvas.toDataURL('image/png');
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);
      };
      
      img.src = 'data:image/svg+xml;base64,' + btoa(svgData);
    },
  },
};
</script>

<style scoped>
.page-container {
  min-height: 100vh;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  padding: 40px 20px;
}

.student-form-container {
  display: flex;
  justify-content: center;
  align-items: flex-start;
}

.form-wrapper {
  width: 100%;
  max-width: 800px;
  padding: 40px;
  background-color: white;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
}

.form-title {
  text-align: center;
  margin-bottom: 40px;
  color: #2c3e50;
  font-size: 2em;
  font-weight: 600;
}

.registration-form {
  display: flex;
  flex-direction: column;
  gap: 24px;
}

.form-row {
  display: flex;
  gap: 20px;
}

.form-group {
  flex: 1;
  min-width: 0;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  font-size: 0.9em;
  color: #4a5568;
  font-weight: 500;
}

.form-input {
  width: 100%;
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

.photo-upload {
  margin-top: 10px;
}

.file-input-container {
  position: relative;
  margin-bottom: 15px;
}

.file-input {
  position: absolute;
  width: 0.1px;
  height: 0.1px;
  opacity: 0;
  overflow: hidden;
  z-index: -1;
}

.file-input-label {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 12px 20px;
  background-color: #edf2f7;
  border-radius: 8px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.file-input-label:hover {
  background-color: #e2e8f0;
}

.upload-icon {
  font-size: 1.2em;
}

.preview {
  margin-top: 20px;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.preview img {
  width: 100%;
  max-width: 300px;
  height: auto;
  display: block;
}

.submit-button {
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
  margin-top: 20px;
}

.submit-button:hover:not(:disabled) {
  background-color: #3182ce;
  transform: translateY(-1px);
}

.submit-button:disabled {
  background-color: #cbd5e0;
  cursor: not-allowed;
}

.button-text {
  display: inline-block;
  transition: transform 0.3s ease;
}

.submit-button:hover .button-text:not(:disabled) {
  transform: translateY(-1px);
}

/* Transitions */
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from, .fade-leave-to {
  opacity: 0;
}

.file-input-label.uploading {
  background-color: #e2e8f0;
  cursor: wait;
  opacity: 0.7;
}

.file-input:disabled + .file-input-label {
  cursor: not-allowed;
  opacity: 0.7;
}

@media (max-width: 768px) {
  .form-row {
    flex-direction: column;
    gap: 15px;
  }

  .form-wrapper {
    padding: 20px;
  }

  .form-title {
    font-size: 1.5em;
    margin-bottom: 30px;
  }
}

.header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.logout-button {
  padding: 8px 16px;
  background-color: #e53e3e;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.9em;
  transition: all 0.3s ease;
}

.logout-button:hover {
  background-color: #c53030;
  transform: translateY(-1px);
}

.students-list-container {
  margin-top: 40px;
  padding: 0 20px;
}

.students-wrapper {
  max-width: 1200px;
  margin: 0 auto;
  background-color: white;
  border-radius: 16px;
  box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  padding: 40px;
}

.section-title {
  text-align: center;
  margin-bottom: 40px;
  color: #2c3e50;
  font-size: 2em;
  font-weight: 600;
}

.students-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 30px;
}

.student-card {
  background-color: #f8fafc;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease;
  display: flex;
  flex-direction: column;
}

.student-card:hover {
  transform: translateY(-5px);
}

.student-photo {
  width: 100%;
  height: 300px;
  overflow: hidden;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f8fafc;
}

.student-photo img {
  width: 100%;
  height: 100%;
  object-fit: contain;
  padding: 10px;
}

.student-info {
  padding: 20px;
  flex-grow: 1;
  background-color: white;
  display: flex;
  flex-direction: column;
}

.student-info h3 {
  margin: 0 0 15px 0;
  color: #2c3e50;
  font-size: 1.2em;
}

.student-info p {
  margin: 8px 0;
  color: #4a5568;
  font-size: 0.9em;
}

.student-info strong {
  color: #2c3e50;
}

.qr-code-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 20px;
  padding: 20px;
  background-color: #ffffff;
  border-radius: 12px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.qr-label {
  margin: 15px 0 10px 0;
  font-size: 0.9em;
  color: #4a5568;
  text-align: center;
  font-weight: 500;
}

.download-button {
  margin-top: 10px;
  padding: 8px 16px;
  background-color: #4299e1;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-size: 0.9em;
  transition: all 0.3s ease;
}

.download-button:hover {
  background-color: #3182ce;
  transform: translateY(-1px);
}

@media (max-width: 768px) {
  .students-wrapper {
    padding: 20px;
  }

  .students-grid {
    grid-template-columns: 1fr;
  }

  .qr-code-container {
    padding: 15px;
  }
}
</style>
