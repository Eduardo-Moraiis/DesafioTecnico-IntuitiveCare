<template>
  <div class="operadoras-view">

    <div class="head">
      <h1>Operadoras de Saúde Registradas</h1>
      <p class="total-count">Total: {{ data.count }} operadoras</p>
    </div>

    <div class="operadoras-list">
      <div v-for="(operadora, index) in data.resultas" :key="index" class="operadora-card">
        <h2>{{ operadora.Razao_Social }}</h2>

        <div class="operadora-info">
          <div class="info-row">
            <span class="info-label">CNPJ:</span>
            <span class="info-value">{{ formatCNPJ(operadora.CNPJ) }}</span>
          </div>

          <div class="info-row">
            <span class="info-label">Registro ANS:</span>
            <span class="info-value">{{ operadora.Registro_ANS }}</span>
          </div>

          <div class="info-row">
            <span class="info-label">Modalidade:</span>
            <span class="info-value">{{ operadora.Modalidade }}</span>
          </div>

          <div class="info-row">
            <span class="info-label">Representante:</span>
            <span class="info-value">{{ operadora.Representante }} ({{ operadora.Cargo_Representante }})</span>
          </div>

          <div class="info-row">
            <span class="info-label">Endereço:</span>
            <span class="info-value">
              {{ operadora.Logradouro }}, {{ operadora.Numero }} - {{ operadora.Bairro }}<br>
              {{ operadora.Cidade }}/{{ operadora.UF }} - CEP: {{ formatCEP(operadora.CEP) }}<br>
              Complemento: {{ operadora.Complemento }}
            </span>
          </div>

          <div class="info-row">
            <span class="info-label">Contato:</span>
            <span class="info-value">
              <span v-if="operadora.Telefone !== 'N/A'">Telefone: ({{ operadora.DDD }}) {{ formatTelefone(operadora.Telefone) }}</span>
              <span v-if="operadora.Fax !== 'N/A'"> | Fax: {{ operadora.Fax }}</span><br>
              <span v-if="operadora.Endereco_eletronico !== 'N/A'">Email: {{ operadora.Endereco_eletronico }}</span>
            </span>
          </div>

          <div class="info-row">
            <span class="info-label">Data de Registro:</span>
            <span class="info-value">{{ formatData(operadora.Data_Registro_ANS) }}</span>
          </div>

          <div class="info-row">
            <span class="info-label">Região de Comercialização:</span>
            <span class="info-value">{{ operadora.Regiao_de_Comercializacao }}</span>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
// Dados fixos (serão substituídos pela sua API via Postman)
import { ref, onMounted, watch } from 'vue'

// Dados da aplicação
const data = ref({ count: 0, resultas: [] })
const loading = ref(false)
const error = ref(null)
const selectedEndpoint = ref(null)
const endpoints = ref([])
const currentEndpointIndex = ref(0)

// Importação do JSON da collection
import postmanCollection from '../assets/Collection_IntuitiveCare.postman_collection.json'

// Processa a collection ao montar o componente
onMounted(() => {
  processPostmanCollection()
})

function processPostmanCollection() {
  try {
    endpoints.value = postmanCollection.item.map(item => ({
      name: item.name,
      method: item.request.method,
      url: item.request.url.raw,
      queries: item.request.url.query || []
    }))

    // Inicia o carregamento automático
    if (endpoints.value.length > 0) {
      selectedEndpoint.value = endpoints.value[0]
      startAutoFetch()
    }
  } catch (err) {
    error.value = 'Erro ao processar a coleção Postman'
    console.error(err)
  }
}

// Carrega dados automaticamente para cada endpoint
const startAutoFetch = () => {
  fetchData()

  // Configura intervalo para mudar de endpoint (opcional)
  const interval = setInterval(() => {
    currentEndpointIndex.value = (currentEndpointIndex.value + 1) % endpoints.value.length
    selectedEndpoint.value = endpoints.value[currentEndpointIndex.value]
  }, 5000) // Muda a cada 10 segundos
}

async function fetchData() {
  if (!selectedEndpoint.value) return

  loading.value = true
  error.value = null

  try {
    const response = await fetch(selectedEndpoint.value.url)

    if (!response.ok) {
      throw new Error(`Erro HTTP: ${response.status}`)
    }

    data.value = await response.json()
  } catch (err) {
    error.value = `Falha ao carregar dados: ${err.message}`
    console.error(err)
  } finally {
    loading.value = false
  }
}

// Observa mudanças no endpoint selecionado
watch(selectedEndpoint, () => {
  fetchData()
})
// Funções de formatação
const formatCNPJ = (cnpj) => {
  const cnpjStr = cnpj.toString().padStart(14, '0')
  return `${cnpjStr.substring(0, 2)}.${cnpjStr.substring(2, 5)}.${cnpjStr.substring(5, 8)}/${cnpjStr.substring(8, 12)}-${cnpjStr.substring(12)}`
}

const formatCEP = (cep) => {
  const cepStr = cep.toString().padStart(8, '0')
  return `${cepStr.substring(0, 5)}-${cepStr.substring(5)}`
}

const formatTelefone = (telefone) => {
  const telStr = telefone.toString()
  return telStr.length === 8 ? `${telStr.substring(0, 4)}-${telStr.substring(4)}` : telStr
}

const formatData = (dataStr) => {
  const options = {day: '2-digit', month: '2-digit', year: 'numeric'}
  return new Date(dataStr).toLocaleDateString('pt-BR', options)
}
</script>

<style scoped>
/* Cabeçalho */
.head {
  background-color: rgba(52, 126, 188, 0.9);
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 25px;
  width: 100%;
  color: white;
  text-align: center;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

.head h1 {
  margin: 0;
  font-size: 1.8rem;
  font-weight: 600;
}

.total-count {
  margin-top: 10px;
  font-size: 1.2rem;
  font-weight: 500;
}

/* Container principal */
.operadoras-view {
  width: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

/* Lista de operadoras */
.operadoras-list {
  display: flex;
  flex-direction: column;
  gap: 30px;
  width: 100%;
}

/* Card de cada operadora */
.operadora-card {
  background: #fff;
  border-radius: 10px;
  padding: 25px;
  box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
  width: 100%;
}

.operadora-card h2 {
  margin: 0 0 15px 0;
  color: #2c3e50;
  font-size: 1.4rem;
  padding-bottom: 12px;
  border-bottom: 2px solid #f0f0f0;
}

/* Informações em grid */
.operadora-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 20px;
}

/* Linhas de informação */
.info-row {
  display: flex;
  margin-bottom: 12px;
}

.info-label {
  font-weight: 600;
  color: #2c3e50;
  padding-right: 10px;
  font-size: 0.95rem;
  word-break: break-all;
}

span{
  word-break: break-all;
}

.info-value {
  color: #4a5568;
  flex: 1;
  line-height: 1.5;
}

/* Responsividade */
@media (max-width: 768px) {
  .operadora-info {
    grid-template-columns: 1fr;
  }

  .info-row {
    flex-direction: column;
    gap: 5px;
  }

  .info-label {
    min-width: 100%;
  }

  .head h1 {
    font-size: 1.5rem;
  }

  .total-count {
    font-size: 1.1rem;
  }
}
</style>