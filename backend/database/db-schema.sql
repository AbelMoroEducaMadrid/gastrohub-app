-- Eliminar el esquema 'public' y todas sus tablas (si existe)
DROP SCHEMA IF EXISTS public CASCADE;

-- Recrear el esquema 'public'
CREATE SCHEMA public;

-- Unidades de medida
CREATE TABLE mt_units (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    symbol VARCHAR(10) UNIQUE NOT NULL
);

-- Roles
CREATE TABLE mt_roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP
);

-- Tipos de atributos
CREATE TABLE mt_attribute_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Atributos
CREATE TABLE mt_attributes (
    id SERIAL PRIMARY KEY,
    type_id INT NOT NULL,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (type_id) REFERENCES mt_attribute_types(id)
);

-- Usuarios
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    phone VARCHAR(50),
    restaurant_id INT,
    status VARCHAR(50) DEFAULT 'active',
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    last_login TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES mt_roles(id)    
);

-- Restaurantes
CREATE TABLE restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    owner_id INT NOT NULL,
    address VARCHAR(255),
    cuisine_type VARCHAR(100),
    opening_hours JSON,
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    active BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMP    
);

-- FKs para relacionar Usuarios y Restaurantes
ALTER TABLE users
ADD CONSTRAINT fk_user_restaurant
FOREIGN KEY (restaurant_id)
REFERENCES restaurants(id);

ALTER TABLE restaurants
ADD CONSTRAINT fk_restaurant_owner
FOREIGN KEY (owner_id)
REFERENCES users(id);

-- Diseños (Layouts)
CREATE TABLE layouts (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- Mesas
CREATE TABLE tables (
    id SERIAL PRIMARY KEY,
    layout_id INT NOT NULL,
    number INT NOT NULL,
    state VARCHAR(50) DEFAULT 'available',
    capacity INT NOT NULL,
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (layout_id) REFERENCES layouts(id)
);

-- Órdenes (Orders)
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    table_id INT NOT NULL,
    waiter_id INT NOT NULL,
    state VARCHAR(50) DEFAULT 'pending',
    notes TEXT,
    urgent BOOLEAN DEFAULT FALSE,
    estimated_time INT,
    total DECIMAL(10,2),
    discount DECIMAL(10,2),
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    completed_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (table_id) REFERENCES tables(id),
    FOREIGN KEY (waiter_id) REFERENCES users(id)
);

-- Ocupaciones de mesas
CREATE TABLE table_occupations (
    id SERIAL PRIMARY KEY,
    table_id INT NOT NULL,
    order_id INT,
    occupied_at TIMESTAMP NOT NULL,
    released_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (table_id) REFERENCES tables(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- Reservas
CREATE TABLE reservations (
    id SERIAL PRIMARY KEY,
    table_id INT NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    number_of_people INT NOT NULL,
    customer_name VARCHAR(255),
    customer_contact VARCHAR(255),
    state VARCHAR(50) DEFAULT 'pending',
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (table_id) REFERENCES tables(id)
);

-- Ingredientes
CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    unit_id INT NOT NULL,
    quantity FLOAT NOT NULL,
    capacity FLOAT NOT NULL,
    cost_per_unit DECIMAL(10,2) NOT NULL,
    min_level FLOAT,
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (unit_id) REFERENCES mt_units(id)
);

-- Relación ingredientes-atributos
CREATE TABLE rel_ingredient_attributes (
    id SERIAL PRIMARY KEY,
    ingredient_id INT NOT NULL,
    attribute_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id),
    FOREIGN KEY (attribute_id) REFERENCES mt_attributes(id)
);

-- Productos preparados
CREATE TABLE prepared_products (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    unit_id INT NOT NULL,
    quantity FLOAT NOT NULL,
    capacity FLOAT NOT NULL,
    cost DECIMAL(10,2),
    min_level FLOAT,
    preparation_time INT,
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (unit_id) REFERENCES mt_units(id)
);

-- Contextos de menú
CREATE TABLE menu_contexts (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    active_from TIME,
    active_to TIME,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- Categorías de menú
CREATE TABLE menu_categories (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    image_url VARCHAR(255),
    available BOOLEAN DEFAULT TRUE,
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- Ítems de menú
CREATE TABLE menu_items (
    id SERIAL PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image_url VARCHAR(255),
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES menu_categories(id)
);

-- Relación ítems de menú-atributos
CREATE TABLE rel_menu_item_attributes (
    id SERIAL PRIMARY KEY,
    menu_item_id INT NOT NULL,
    attribute_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id),
    FOREIGN KEY (attribute_id) REFERENCES mt_attributes(id)
);

-- Asignaciones de menú
CREATE TABLE menu_assignments (
    id SERIAL PRIMARY KEY,
    menu_context_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    price DECIMAL(10,2),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (menu_context_id) REFERENCES menu_contexts(id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- Relación consumos de ítems de menú
CREATE TABLE rel_menu_item_consumptions (
    id SERIAL PRIMARY KEY,
    menu_item_id INT NOT NULL,
    ingredient_id INT,
    prepared_product_id INT,
    quantity FLOAT NOT NULL,
    unit_id INT NOT NULL,
    CONSTRAINT check_one_not_null CHECK (
        (ingredient_id IS NOT NULL AND prepared_product_id IS NULL) OR
        (ingredient_id IS NULL AND prepared_product_id IS NOT NULL)
    ),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id),
    FOREIGN KEY (prepared_product_id) REFERENCES prepared_products(id),
    FOREIGN KEY (unit_id) REFERENCES mt_units(id)
);

-- Ofertas especiales
CREATE TABLE special_offers (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    offer_type VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    start_date DATE,
    end_date DATE,
    active_from TIME,
    active_to TIME,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- Relación ofertas-productos
CREATE TABLE rel_offer_products (
    id SERIAL PRIMARY KEY,
    offer_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (offer_id) REFERENCES special_offers(id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- Ítems de pedido
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity FLOAT NOT NULL,
    notes TEXT,
    state VARCHAR(50) DEFAULT 'pending',
    price_at_order DECIMAL(10,2) NOT NULL,
    prepared_at TIMESTAMP,
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- Pagos
CREATE TABLE payments (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    method VARCHAR(50) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    state VARCHAR(50) DEFAULT 'pending',
    transaction_id VARCHAR(255),
    payment_timestamp TIMESTAMP,
    refund_amount DECIMAL(10,2),
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- Turnos
CREATE TABLE shifts (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- Retroalimentación
CREATE TABLE feedback (
    id SERIAL PRIMARY KEY,
    order_id INT,
    rating INT,
    comment TEXT,
    created_by INT,
    updated_by INT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP,
    deleted_at TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id)
);