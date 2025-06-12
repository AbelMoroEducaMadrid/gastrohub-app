-- Eliminar el esquema 'public' y todas sus tablas (si existe)
DROP SCHEMA IF EXISTS public CASCADE;

-- Recrear el esquema 'public'
CREATE SCHEMA public;

-- ### Tipos Enumerados (ENUM)
-- Estos tipos restringen los valores permitidos para mejorar la integridad de los datos.
CREATE TYPE order_state AS ENUM ('pendiente', 'en progreso', 'servida', 'cancelada');
CREATE CAST (varchar AS order_state) WITH INOUT AS IMPLICIT;
CREATE TYPE order_item_state AS ENUM ('esperando', 'preparándose', 'listo', 'entregado', 'cancelado');
CREATE CAST (varchar AS order_item_state) WITH INOUT AS IMPLICIT;
CREATE TYPE table_state AS ENUM ('disponible', 'ocupada', 'reservada');
CREATE CAST (varchar AS table_state) WITH INOUT AS IMPLICIT;
CREATE TYPE payment_state AS ENUM ('pendiente', 'completado', 'fallido', 'cancelado');
CREATE CAST (varchar AS payment_state) WITH INOUT AS IMPLICIT;
CREATE TYPE payment_method AS ENUM ('efectivo', 'tarjeta', 'móvil', 'vale');
CREATE CAST (varchar AS payment_method) WITH INOUT AS IMPLICIT;
CREATE TYPE reservation_state AS ENUM ('pendiente', 'cancelada', 'no presentada', 'completada');
CREATE CAST (varchar AS reservation_state) WITH INOUT AS IMPLICIT;

-- ### Tablas Maestras (mt_*)
CREATE TABLE mt_units
(
    id     SERIAL PRIMARY KEY,
    name   VARCHAR(50) UNIQUE NOT NULL,
    symbol VARCHAR(10) UNIQUE NOT NULL
);

CREATE TABLE mt_roles
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE mt_attributes
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(100) UNIQUE NOT NULL,
    description TEXT                NOT NULL
);

CREATE TABLE mt_categories
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- ### Planes de pago
CREATE TABLE payment_plans
(
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(255)                        NOT NULL,
    description     TEXT                                NOT NULL,
    features        TEXT[]                              NOT NULL,
    monthly_price   DECIMAL(10, 2)                      NOT NULL CHECK (monthly_price >= 0),
    yearly_discount INT                                 NOT NULL DEFAULT 0 CHECK (yearly_discount >= 0),
    max_users       INT CHECK (max_users > 0),
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- ### Restaurantes
CREATE TABLE restaurants
(
    id                    SERIAL PRIMARY KEY,
    name                  VARCHAR(255)                        NOT NULL,
    address               VARCHAR(255)                        NOT NULL,
    cuisine_type          VARCHAR(100)                        NOT NULL,
    description           TEXT                                NOT NULL,
    invitation_code       VARCHAR(20) UNIQUE,
    invitation_expires_at TIMESTAMP,
    payment_plan_id       INT                                 NOT NULL,
    paid                  BOOLEAN   DEFAULT FALSE,
    created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (payment_plan_id) REFERENCES payment_plans (id) ON DELETE CASCADE
);

-- ### Usuarios
CREATE TABLE users
(
    id                    SERIAL PRIMARY KEY,
    name                  VARCHAR(255)                        NOT NULL,
    email                 VARCHAR(255) UNIQUE                 NOT NULL,
    password_hash         VARCHAR(255)                        NOT NULL,
    verified              BOOLEAN   DEFAULT FALSE             NOT NULL,
    role_id               INT                                 NOT NULL,
    phone                 VARCHAR(50) UNIQUE,
    restaurant_id         INT,
    last_login            TIMESTAMP,
    failed_login_attempts INTEGER   DEFAULT 0                 NOT NULL,
    locked_until          TIMESTAMP,
    created_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at            TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (role_id) REFERENCES mt_roles (id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
);

-- ### Diseños (Layouts)
CREATE TABLE layouts
(
    id            SERIAL PRIMARY KEY,
    restaurant_id INT                                 NOT NULL,
    name          VARCHAR(100)                        NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE
);

-- ### Mesas
CREATE TABLE tables
(
    id         SERIAL PRIMARY KEY,
    layout_id  INT                                 NOT NULL,
    number     INT                                 NOT NULL CHECK (number > 0),
    state      table_state                         NOT NULL,
    capacity   INT                                 NOT NULL CHECK (capacity > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    UNIQUE (layout_id, number),
    FOREIGN KEY (layout_id) REFERENCES layouts (id) ON DELETE CASCADE
);

-- ### Comandas
CREATE TABLE orders
(
    id             SERIAL PRIMARY KEY,
    restaurant_id  INT                                 NOT NULL,
    table_id       INT,
    state          order_state                         NOT NULL,
    notes          TEXT,
    urgent         BOOLEAN   DEFAULT FALSE,
    payment_state  payment_state                       NOT NULL,
    payment_method payment_method                      NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES tables (id) ON DELETE CASCADE
);

-- ### Ingredientes
CREATE TABLE ingredients
(
    id            SERIAL PRIMARY KEY,
    restaurant_id INT                                 NOT NULL,
    name          VARCHAR(255)                        NOT NULL,
    unit_id       INT                                 NOT NULL,
    stock         DECIMAL(10, 2)                      NOT NULL CHECK (stock >= 0),
    cost_per_unit DECIMAL(10, 2)                      NOT NULL CHECK (cost_per_unit >= 0),
    min_stock     DECIMAL(10, 2) CHECK (min_stock >= 0),
    is_composite  BOOLEAN   DEFAULT FALSE             NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE,
    FOREIGN KEY (unit_id) REFERENCES mt_units (id) ON DELETE CASCADE
);

-- ### Relación Ingredientes Compuestos-Componentes
CREATE TABLE rel_ingredient_ingredients
(
    parent_ingredient_id    INT                                 NOT NULL,
    component_ingredient_id INT                                 NOT NULL,
    quantity                DECIMAL(10, 2)                      NOT NULL CHECK (quantity > 0),
    unit_id                 INT                                 NOT NULL,
    created_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at              TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (parent_ingredient_id, component_ingredient_id),
    FOREIGN KEY (parent_ingredient_id) REFERENCES ingredients (id) ON DELETE CASCADE,
    FOREIGN KEY (component_ingredient_id) REFERENCES ingredients (id) ON DELETE CASCADE,
    FOREIGN KEY (unit_id) REFERENCES mt_units (id) ON DELETE CASCADE
);

-- ### Relación Ingredientes-Atributos
CREATE TABLE rel_ingredients_attributes
(
    ingredient_id INT NOT NULL,
    attribute_id  INT NOT NULL,
    PRIMARY KEY (ingredient_id, attribute_id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients (id) ON DELETE CASCADE,
    FOREIGN KEY (attribute_id) REFERENCES mt_attributes (id) ON DELETE CASCADE
);

-- ### Productos
CREATE TABLE products
(
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(255)                        NOT NULL,
    restaurant_id INT                                 NOT NULL,
    total_cost    DECIMAL(10, 2)                      NOT NULL CHECK (total_cost >= 0),
    available     BOOLEAN   DEFAULT TRUE,
    is_kitchen    BOOLEAN   DEFAULT TRUE,
    category_id   INT                                 NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants (id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES mt_categories (id) ON DELETE CASCADE
);

-- ### Relación Productos-Ingredientes
CREATE TABLE rel_products_ingredients
(
    product_id    INT                                 NOT NULL,
    ingredient_id INT                                 NOT NULL,
    quantity      DECIMAL(10, 2)                      NOT NULL CHECK (quantity > 0),
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    PRIMARY KEY (product_id, ingredient_id),
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    FOREIGN KEY (ingredient_id) REFERENCES ingredients (id) ON DELETE CASCADE
);

-- ### Relación Productos-Comandas
CREATE TABLE rel_orders_products
(
    id         SERIAL PRIMARY KEY,
    order_id   INT                                 NOT NULL,
    product_id INT                                 NOT NULL,
    price      DECIMAL(10, 2)                      NOT NULL CHECK (price >= 0),
    notes      TEXT,
    state      order_item_state                    NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
);