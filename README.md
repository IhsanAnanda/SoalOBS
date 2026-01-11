# Spring Boot Kafka Project (OBS Test)

This project is a microservices-based application using Spring Boot and Apache Kafka for asynchronous communication. It manages Items, Orders, and Inventory through a distributed system architecture.

## 🏗 Architecture

The system consists of 4 main services communicating via Kafka topics:

| Service | Port | Description |
| :--- | :--- | :--- |
| **Gateway** | `8090` | entry point for all API requests. Orchestrates requests to other services via Kafka. |
| **Inventory** | `8091` | Manages stock levels (`inventory` table). |
| **Order** | `8092` | Manages customer orders (`orders` table). |
| **Item** | `8093` | Manages product information (`item` table). |

**Infrastructure:**
*   **Database**: MySQL (Single `testDb`)
*   **Message Broker**: Apache Kafka
*   **Coordination**: Zookeeper
*   **Kafka UI**: Kafdrop

## 🗄 Database Schema

The project uses a MySQL database named `testDb` with the following tables:

*   **`item`**: Stores product details.
    *   `id` (PK), `name`, `price`
*   **`orders`**: Stores order transactions.
    *   `order_no` (PK), `item_id`, `qty`, `price`
*   **`inventory`**: Tracks stock movements.
    *   `id` (PK), `item_id`, `qty`, `type` ('T' = Top-up/Add, 'W' = Withdraw/Remove)

## 🚀 Getting Started

### Prerequisites
*   Java 11 or higher
*   Maven
*   Docker & Docker Compose

### 1. Start Infrastructure
Run the following command to start MySQL (if containerized), Zookeeper, Kafka, and Kafdrop:

```bash
docker-compose up -d
```

*   **Kafka**: `localhost:9092`
*   **Kafdrop**: `http://localhost:9000`

### 2. Database Setup
Execute the `db.sql` script in your MySQL instance to create the schema and populate initial data.

### 3. Run Services
Start each service using Maven:

```bash
# In separate terminals:
cd SourceCode/gateway && mvn spring-boot:run
cd SourceCode/inventory && mvn spring-boot:run
cd SourceCode/item && mvn spring-boot:run
cd SourceCode/order && mvn spring-boot:run
```

## 📡 API Usage

The API is exposed via the **Gateway Service** at `http://localhost:8090`.
A **Postman Collection** (`OBS Copy.postman_collection.json`) is included in the root directory for testing.

### Common Endpoints

**Item Service**
*   `POST /getItem` - List items
*   `POST /getItemById` - Get item details
*   `POST /insertItem` - Add a new item
*   `POST /updateItem` - Update item details
*   `POST /deleteItem` - Remove an item

**Order Service**
*   `POST /getOrder` - List orders
*   `POST /insertOrder` - Create a new order
*   `POST /updateOrder` - Update an order

**Kafka Communication**
All HTTP requests to the Gateway are converted into Kafka messages (e.g., `get-item-request`), processed by the respective service, and the result is returned via a response topic (e.g., `get-item-response`).
