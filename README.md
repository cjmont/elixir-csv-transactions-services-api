# Transactions API

Esta es una API REST creada con Elixir y Phoenix que permite ingresar transacciones y descargar un archivo CSV con todas las transacciones ingresadas. Los campos de la transacción están definidos en el cuerpo de la solicitud. La API también requiere autenticación a través de los headers `shk_usr` y `shk_pwd`.

## Requisitos

- Elixir
- Phoenix
- Docker
- Docker Compose

## Configuración del Proyecto

### Paso 1: Clonar el Repositorio

```sh
git clone <URL_DEL_REPOSITORIO>
cd <NOMBRE_DEL_REPOSITORIO>
```


### Paso 2: Iniciar los Contenedores

Ejecuta el siguiente comando para iniciar los contenedores Docker:

```sh
docker-compose up --build
```

## Uso de la API

### Endpoint: Crear Transacción

**URL:** `/api/transactions`  
**Método:** `POST`  
**Headers:**  
- `Content-Type`: `application/json`
- `shk_usr`: `your_username`
- `shk_pwd`: `your_password`

**Cuerpo de la Solicitud:**

```json
{
  "transaction": {
    "shk_id": "550e8400-e29b-41d4-a716-446655440000",
    "debtor_name": "Carlos M",
    "creditor_name": "Paola V",
    "debtor_id": "123456",
    "creditor_id": "654321",
    "amount": 100.50,
    "operation_date": "2024-05-24T21:48:00Z",
    "debtor_bank": "Bank A",
    "creditor_bank": "Bank B"
  }
}
```

**Ejemplo de Solicitud cURL:**

```sh
curl -X POST http://localhost:8098/api/transactions \
  -H "Content-Type: application/json" \
  -H "shk_usr: your_username" \
  -H "shk_pwd: your_password" \
  -d '{
    "transaction": {
      "shk_id": "550e8400-e29b-41d4-a716-446655440000",
      "debtor_name": "Carlos M",
      "creditor_name": "Paola V",
      "debtor_id": "123456",
      "creditor_id": "654321",
      "amount": 100.50,
      "operation_date": "2024-05-24T21:48:00Z",
      "debtor_bank": "Bank A",
      "creditor_bank": "Bank B"
    }
  }'
```

### Endpoint: Generar CSV de Transacciones

**URL:** `/api/transactions/generate_csv`  
**Método:** `POST`  
**Headers:**  
- `Content-Type`: `application/json`
- `shk_usr`: `your_username`
- `shk_pwd`: `your_password`

**Cuerpo de la Solicitud:** (vacío)

**Ejemplo de Solicitud cURL:**

```sh
curl -X POST http://localhost:8098/api/transactions/generate_csv \
  -H "Content-Type: application/json" \
  -H "shk_usr: your_username" \
  -H "shk_pwd: your_password"
```

**Respuesta:**

```json
{
  "status": "CSV generation started",
  "link": "/api/transactions/download_async"
}
```

### Endpoint: Descargar CSV de Transacciones

**URL:** `/api/transactions/download_async`  
**Método:** `GET`  
**Headers:**  
- `Content-Type`: `application/json`
- `shk_usr`: `your_username`
- `shk_pwd`: `your_password`

**Ejemplo de Solicitud cURL:**

```sh
curl -X GET http://localhost:8098/api/transactions/download_async \
  -H "Content-Type: application/json" \
  -H "shk_usr: your_username" \
  -H "shk_pwd: your_password"
```

**Posibles Respuestas:**

- **CSV No Está Listo Aún:**

  **HTTP Status:** 425 Too Early  
  **Cuerpo de la Respuesta:**

  ```json
  {
    "error": "CSV file is not ready yet"
  }
  ```

- **CSV Listo para Descarga:**

  **HTTP Status:** 200 OK  
  **Headers:**
  - `Content-Type`: `text/csv`
  - `Content-Disposition`: `attachment; filename="transactions.csv"`

  El contenido del archivo CSV se devolverá en el cuerpo de la respuesta.

### Endpoint: Descargar CSV de Transacciones (Sincronizado)

**URL:** `/api/transactions/download`  
**Método:** `GET`  
**Headers:**  
- `Content-Type`: `application/json`
- `shk_usr`: `your_username`
- `shk_pwd`: `your_password`

**Ejemplo de Solicitud cURL:**

```sh
curl -X GET http://localhost:8098/api/transactions/download \
  -H "Content-Type: application/json" \
  -H "shk_usr: your_username" \
  -H "shk_pwd: your_password"
```

**Respuesta:**

```json
{
    "status": "CSV file ready",
    "link": "/app/_build/dev/lib/transactions_api/priv/static/transactions.csv"
}
```



## Licencia

Este proyecto está licenciado bajo la Licencia MIT - consulta el archivo [LICENSE](LICENSE) para más detalles.
