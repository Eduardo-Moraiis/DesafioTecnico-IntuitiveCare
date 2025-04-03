<template>
  <body>
    <div class="app-container">
      <OperadorasView />
    </div>
  </body>
</template>

<script setup>
import OperadorasView from './components/OperadorasList.vue'
</script>

<style>
.app-container {
  width: 100%;
  height: 100%;
  background: #6C7A89;
  overflow-x: hidden;
}

/* Remove margens padrão do body */
body {
 margin: 0;
  width: 100vw;
  height: 100vh;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  overflow-x: hidden;
}
</style>