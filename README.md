# Gastro & Hub

**Gastro & Hub** es una aplicación multiplataforma diseñada para optimizar la gestión de bares y restaurantes, desarrollada como Trabajo Final de Grado (TFG) del CFGS en Desarrollo de Aplicaciones Multiplataforma (DAM). Centraliza la operativa hostelera con comandas en tiempo real, gestión de inventario, turnos y menús, mejorando la coordinación entre camareros, cocineros y gerentes.

## Descripción

"Gastro & Hub" busca revolucionar la gestión de pequeños y medianos negocios hosteleros en España, ofreciendo una solución moderna, accesible y de bajo coste. Permite a los camareros registrar pedidos desde móviles en tiempo real, al dueño controlar inventarios con análisis predictivo, gestionar pagos digitales y generar informes detallados. Construida con tecnologías actuales como Spring Boot, Flutter y PostgreSQL, es adaptable a cualquier negocio y accesible desde dispositivos estándar, marcando una diferencia en la eficiencia operativa y la experiencia del cliente.

### Características principales

- **Comandas en tiempo real**: Registro y seguimiento instantáneo de pedidos entre sala y cocina.
- **Gestión de inventario**: Control de existencias con alertas y análisis predictivo para compras.
- **Pagos digitales**: Integración sencilla para pagos mediante códigos QR o efectivo.
- **Informes detallados**: Análisis de ventas, reservas y tendencias para decisiones informadas.
- **Multiplataforma**: Compatible con Android, iOS, Windows y Linux.

## Estructura del Proyecto

- **`backend/`**: Contiene el código del backend desarrollado con Spring Boot, incluyendo la API REST y WebSocket para comunicación en tiempo real.
- **`frontend/`**: Incluye el frontend desarrollado con Flutter, compatible con Android, iOS, Windows y Linux.
- **`deployment/`**: Archivos de configuración para desplegar la aplicación usando Docker y Docker Compose.
- **`docs/`**: Documentación técnica, diagramas y análisis del proyecto (disponible en la [Wiki](https://github.com/AbelMoroEducaMadrid/gastrohub-app/wiki)).

## Tecnologías Utilizadas

### Desarrollo

- **Backend**: Java, Spring Boot, REST, WebSocket.
- **Frontend**: Dart, Flutter (multiplataforma).
- **Base de datos**: PostgreSQL.
- **Comunicaciones**: WebSocket (notificaciones en tiempo real), REST (consultas y gestión).
- **Pagos**: Stripe API (procesamiento de pagos digitales).
- **Documentos**: iTextPDF (generación de menús), ZXing (códigos QR).

### Despliegue

- **Docker**: Empaquetado del backend y base de datos.
- **Docker Compose**: Configuración de despliegue local.
- **Opcional**: Servicios en la nube (AWS, GCP, Azure) para producción.

### Herramientas

- **Control de versiones**: Git, GitHub.
- **Entorno de desarrollo**: IntelliJ IDEA Ultimate, Android Studio, Visual Studio Code.
- **Pruebas**: JUnit, Flutter Test, JMeter, Testcontainers.
- **Gestión**: ProjectLibre, Excel.
- **Diagramas**: Draw.io.

## Estado del Proyecto

- **Completado**:
  - Análisis completo: Requisitos funcionales y no funcionales, historias de usuario y matriz de trazabilidad.
  - Diseño inicial: Arquitectura del sistema (modelo cliente-servidor de tres capas), modelo de datos y casos de uso.
- **En progreso**:
  - Desarrollo del backend: Configuración inicial de Spring Boot y creación de la API REST.
  - Desarrollo del frontend: Configuración inicial de Flutter para multiplataforma.
- **Pendiente**:
  - Implementación completa de las funcionalidades (gestión de pedidos, inventario, pagos, etc.).
  - Pruebas unitarias y de integración con JUnit, Flutter Test y JMeter.
  - Despliegue y configuración en entornos de producción con Docker.