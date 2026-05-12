<template>
  <div class="login-page">
    <div class="login-card">
      <div class="login-header">
        <h1>ProyectoHorario</h1>
        <p>Accede con tu cuenta</p>
      </div>

      <form class="login-form" @submit.prevent="handleLogin">
        <div class="form-group">
          <label for="usuario">Usuario</label>
          <input
            id="usuario"
            v-model="form.usuario"
            type="text"
            placeholder="Introduce tu usuario"
            autocomplete="username"
            required
          />
        </div>

        <div class="form-group">
          <label for="contrasena">Contraseña</label>
          <input
            id="contrasena"
            v-model="form.contrasena"
            type="password"
            placeholder="Introduce tu contraseña"
            autocomplete="current-password"
            required
          />
        </div>

        <p v-if="error" class="error-msg">{{ error }}</p>

        <button type="submit" :disabled="cargando">
          {{ cargando ? 'Accediendo...' : 'Entrar' }}
        </button>
      </form>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const form = ref({ usuario: '', contrasena: '' })
const error = ref('')
const cargando = ref(false)

async function handleLogin() {
  error.value = ''
  cargando.value = true
  try {
    // TODO: llamar a la API de autenticacion
    console.log('Login con:', form.value.usuario)
  } catch {
    error.value = 'Usuario o contraseña incorrectos.'
  } finally {
    cargando.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #f0f2f5;
}

.login-card {
  background: #ffffff;
  border-radius: 12px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.10);
  padding: 48px 40px;
  width: 100%;
  max-width: 400px;
}

.login-header {
  text-align: center;
  margin-bottom: 36px;
}

.login-header h1 {
  font-size: 1.75rem;
  font-weight: 700;
  color: #1a1a2e;
  margin: 0 0 6px 0;
}

.login-header p {
  color: #6b7280;
  font-size: 0.95rem;
  margin: 0;
}

.login-form {
  display: flex;
  flex-direction: column;
  gap: 20px;
}

.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.form-group label {
  font-size: 0.875rem;
  font-weight: 600;
  color: #374151;
}

.form-group input {
  padding: 10px 14px;
  border: 1.5px solid #d1d5db;
  border-radius: 8px;
  font-size: 0.95rem;
  color: #111827;
  outline: none;
  transition: border-color 0.2s;
}

.form-group input:focus {
  border-color: #4f46e5;
}

.error-msg {
  color: #dc2626;
  font-size: 0.875rem;
  margin: 0;
  text-align: center;
}

button[type='submit'] {
  padding: 11px;
  background-color: #4f46e5;
  color: #ffffff;
  border: none;
  border-radius: 8px;
  font-size: 1rem;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.2s;
  margin-top: 4px;
}

button[type='submit']:hover:not(:disabled) {
  background-color: #4338ca;
}

button[type='submit']:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
