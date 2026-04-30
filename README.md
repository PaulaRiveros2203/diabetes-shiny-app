# 🩺 Análisis de Diabetes - Pima Indians Dataset

Aplicación interactiva desarrollada en **R y Shiny** para el análisis exploratorio del dataset *Pima Indians Diabetes*.
Permite visualizar patrones relevantes asociados al diagnóstico de diabetes mediante gráficas dinámicas.

---

## 🚀 Descripción del Proyecto

Este proyecto tiene como objetivo analizar variables clínicas como:

* Glucosa
* Edad
* Índice de Masa Corporal (IMC)
* Presión arterial
* Historial médico

A través de una aplicación web interactiva, se facilita la exploración de los datos mediante filtros y visualizaciones.

---

## 📊 Funcionalidades

La aplicación incluye:

* 🔎 **Filtros interactivos**

  * Rango de edad
  * Nivel de glucosa
  * Tipo de diagnóstico (diabético / no diabético)

* 📈 **Visualizaciones**

  1. Gráfica de barras (distribución de pacientes)
  2. Scatter plot (Edad vs Glucosa)
  3. Boxplot (IMC vs diagnóstico)
  4. Histograma (distribución de glucosa)
  5. Heatmap (correlación entre variables)

---

## 🧠 Análisis Realizado

* Se identificó que la **glucosa** es una de las variables con mayor relación con el diagnóstico de diabetes.
* El **IMC** presenta diferencias entre pacientes diabéticos y no diabéticos.
* Las correlaciones entre variables son en general **débiles**, lo que sugiere que la diabetes depende de múltiples factores.

---

## 🛠️ Tecnologías Utilizadas

* R
* Shiny
* ggplot2
* dplyr
* reshape2

---

## 📂 Estructura del Proyecto

```
📁 PacientesConDiabetes
│
├── app.R
├── diabetes.csv
└── README.md
```

---

## ▶️ Cómo ejecutar el proyecto

1. Clonar el repositorio:

```bash
git clone <URL_DEL_REPO>
```

2. Abrir el archivo `app.R` en RStudio

3. Ejecutar:

```r
shiny::runApp()
```

---

## 🌐 Aplicación en línea

👉 [Ver aplicación en ShinyApps](https://pacientesdiabetes.shinyapps.io/fabianpaula/)

---

## 👩‍💻 Autor

**María Paula Riveros**
**Fabian Vasquez**

---

## 📌 Notas

Este proyecto fue desarrollado con fines académicos como parte del análisis de datos y visualización interactiva.

---
