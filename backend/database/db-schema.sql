-- Eliminar el esquema 'public' y todas sus tablas (si existe)
DROP SCHEMA IF EXISTS public CASCADE;

-- Recrear el esquema 'public'
CREATE SCHEMA public;

-- ### Tipos Enumerados (ENUM)
-- Estos tipos restringen los valores permitidos para mejorar la integridad de los datos.
CREATE TYPE order_state AS ENUM ('pending', 'in_progress', 'served', 'cancelled');
-- Estados posibles de una comanda: pendiente, en progreso, servida, cancelada

CREATE TYPE order_item_state AS ENUM ('waiting', 'preparing', 'ready', 'delivered', 'cancelled');
-- Estados de un ítem en una comanda: esperando, preparándose, listo, entregado, cancelado

CREATE TYPE table_state AS ENUM ('available', 'occupied', 'reserved', 'cleaning', 'disabled');
-- Estados de una mesa: disponible, ocupada, reservada, en limpieza, deshabilitada

CREATE TYPE payment_state AS ENUM ('pending', 'completed', 'failed', 'cancelled');
-- Estados de pago: pendiente, completado, fallido, cancelado

CREATE TYPE payment_method AS ENUM ('cash', 'card', 'mobile', 'voucher');
-- Métodos de pago: efectivo, tarjeta, móvil, vale

CREATE TYPE reservation_state AS ENUM ('pending', 'confirmed', 'cancelled', 'no_show', 'completed');
-- Estados de una reserva: pendiente, confirmada, cancelada, no presentada, completada

-- ### Tablas Maestras (mt_*)
-- Contienen datos de referencia que no cambian frecuentemente.
CREATE TABLE mt_units (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL, -- Nombre de la unidad (ej. 'Kilogramo')
    symbol VARCHAR(10) UNIQUE NOT NULL -- Símbolo de la unidad (ej. 'kg')
);

CREATE TABLE mt_roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL -- Nombre del rol (ej. 'ROLE_ADMIN')
);

CREATE TABLE mt_attributes (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL, -- Nombre del atributo (ej. 'Sin gluten')
    description TEXT NOT NULL -- Descripción del atributo
);

-- ### Restaurantes
-- Información básica de cada restaurante.
CREATE TABLE restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL, -- Nombre del restaurante
    address VARCHAR(255) NOT NULL, -- Dirección
    cuisine_type VARCHAR(100) NOT NULL, -- Tipo de cocina (ej. 'Italiana')
    description TEXT NOT NULL, -- Descripción del restaurante
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de creación
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL, -- Fecha de última actualización
    deleted_at TIMESTAMP -- Fecha de eliminación (para borrado lógico)
);

-- ### Usuarios
-- Empleados y administradores del sistema.
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL, -- Nombre del usuario
    email VARCHAR(255) UNIQUE NOT NULL, -- Email único
    password_hash VARCHAR(255) NOT NULL, -- Hash de la contraseña
	verified BOOLEAN DEFAULT TRUE NOT NULL, -- Para la verificación con email
    role_id INT NOT NULL, -- ID del rol (referencia a mt_roles)
    phone VARCHAR(50) UNIQUE, -- Teléfono (único, aunque podría ser NULL)
    restaurant_id INT, -- ID del restaurante al que pertenece (NULL para administradores generales)
    last_login TIMESTAMP, -- Fecha del último login
    failed_login_attempts INTEGER DEFAULT 0 NOT NULL, -- Intentos fallidos de login
    locked_until TIMESTAMP, -- Fecha hasta la cual la cuenta está bloqueada
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES mt_roles(id),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- ### Diseños (Layouts)
-- Planos de las áreas del restaurante (ej. 'Planta Baja', 'Terraza').
CREATE TABLE layouts (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL, -- ID del restaurante
    name VARCHAR(100) NOT NULL, -- Nombre del diseño (ej. 'Planta Baja')
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- ### Mesas
-- Mesas físicas en cada diseño del restaurante.
CREATE TABLE tables (
    id SERIAL PRIMARY KEY,
    layout_id INT NOT NULL, -- ID del diseño al que pertenece
    number INT NOT NULL, -- Número de la mesa (único por diseño)
    state table_state NOT NULL, -- Estado actual de la mesa
    capacity INT NOT NULL, -- Capacidad máxima de personas
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    UNIQUE (layout_id, number), -- Asegura que el número de mesa sea único por diseño
    FOREIGN KEY (layout_id) REFERENCES layouts(id)
);

-- ### Reservas
-- Reservas de mesas por clientes.
CREATE TABLE reservations (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL, -- ID del restaurante
    reserved_at TIMESTAMP NOT NULL, -- Fecha y hora de la reserva
    customer_name VARCHAR(255) NOT NULL, -- Nombre del cliente
    customer_contact VARCHAR(255), -- Contacto del cliente (podría ser obligatorio)
    number_of_people INT NOT NULL, -- Número de personas
    state reservation_state NOT NULL, -- Estado de la reserva
    notes TEXT, -- Notas adicionales
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- ### Relación Reservas-Mesas
-- Mesas asignadas a una reserva.
CREATE TABLE rel_reservation_tables (
    reservation_id INT NOT NULL,
    table_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    PRIMARY KEY (reservation_id, table_id), -- Clave compuesta para evitar duplicados
    FOREIGN KEY (reservation_id) REFERENCES reservations(id),
    FOREIGN KEY (table_id) REFERENCES tables(id)
);

-- ### Comandas
-- Pedidos realizados por los clientes.
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL, -- ID del restaurante
    state order_state NOT NULL, -- Estado de la comanda
    notes TEXT, -- Notas adicionales
    urgent BOOLEAN DEFAULT FALSE, -- Si es urgente
    payment_state payment_state NOT NULL, -- Estado del pago
    payment_method payment_method NOT NULL, -- Método de pago    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- ### Relación Comandas-Mesas
-- Mesas asociadas a una comanda.
CREATE TABLE rel_order_tables (
    order_id INT NOT NULL,
    table_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    PRIMARY KEY (order_id, table_id), -- Clave compuesta
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (table_id) REFERENCES tables(id)
);

-- ### Categorías de Menú
-- Categorías para organizar los productos (ej. 'Antipasti', 'Pizzas').
CREATE TABLE menu_categories (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL, -- ID del restaurante
    name VARCHAR(255) NOT NULL, -- Nombre de la categoría
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- ### Ingredientes
-- Ingredientes usados en los productos.
CREATE TABLE ingredients (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL, -- ID del restaurante
    name VARCHAR(255) NOT NULL, -- Nombre del ingrediente
    unit_id INT NOT NULL, -- ID de la unidad de medida (referencia a mt_units)
    stock DECIMAL(10, 2) NOT NULL, -- Cantidad en inventario
    cost_per_unit DECIMAL(10, 2) NOT NULL, -- Costo por unidad
    min_stock DECIMAL(10, 2), -- Nivel mínimo para reordenar
    is_composite BOOLEAN DEFAULT FALSE NOT NULL, -- Si es un ingrediente compuesto (ej. 'Salsa de tomate')
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id),
    FOREIGN KEY (unit_id) REFERENCES mt_units(id)
);

-- ### Relación Ingredientes Compuestos-Componentes
-- Ingredientes que componen otros ingredientes compuestos.
CREATE TABLE rel_ingredient_ingredients (
    parent_ingredient_id INT NOT NULL, -- ID del ingrediente compuesto
    component_ingredient_id INT NOT NULL, -- ID del ingrediente componente
    quantity DECIMAL(10, 2) NOT NULL, -- Cantidad del componente
    unit_id INT NOT NULL, -- ID de la unidad de medida para la cantidad
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    PRIMARY KEY (parent_ingredient_id, component_ingredient_id), -- Clave compuesta
    FOREIGN KEY (parent_ingredient_id) REFERENCES ingredients(id),
    FOREIGN KEY (component_ingredient_id) REFERENCES ingredients(id),
    FOREIGN KEY (unit_id) REFERENCES mt_units(id)
);

-- ### Relación Ingredientes-Atributos
-- Atributos asociados a los ingredientes (ej. 'Sin gluten', 'Vegano').
CREATE TABLE rel_ingredient_attributes (
    ingredient_id INT NOT NULL,
    attribute_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    PRIMARY KEY (ingredient_id, attribute_id), -- Clave compuesta
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id),
    FOREIGN KEY (attribute_id) REFERENCES mt_attributes(id)
);

-- ### Productos
-- Platos y bebidas que se ofrecen en el menú.
CREATE TABLE products (
    id SERIAL PRIMARY KEY,    
    name VARCHAR(255) NOT NULL, -- Nombre del producto
    total_cost DECIMAL(10, 2) NOT NULL, -- Calculado desde los ingredientes
    available BOOLEAN DEFAULT TRUE, -- Si está disponible para ordenar
    is_kitchen BOOLEAN DEFAULT TRUE, -- Si requiere preparación en cocina (FALSE para bebidas, por ejemplo)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP    
);

-- ### Relación Productos-Ingredientes
-- Ingredientes necesarios para cada producto.
CREATE TABLE rel_product_ingredients (
    product_id INT NOT NULL,
    ingredient_id INT NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL, -- Cantidad del ingrediente necesaria
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    PRIMARY KEY (product_id, ingredient_id), -- Clave compuesta
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

-- ### Ítems de Menú
-- Representan ítems individuales o combinaciones que se pueden ordenar, como productos simples o promociones (ej. "2x1").
CREATE TABLE menu_items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL, -- Nombre del ítem de menú (ej. "2x1" o "Oferta San Valentín")
    category_id INT NOT NULL,   -- ID de la categoría a la que pertenece (ej. "Pizzas", "Ofertas")
    price DECIMAL(10,2) NOT NULL, -- Precio de venta del ítem, calculado a partir del costo total más un margen
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES menu_categories(id)
);

-- ### Relación Ítems de Menú - Productos
-- Define qué productos componen cada ítem de menú y en qué cantidad (ej. un combo con 2 pizzas y 1 bebida).
CREATE TABLE rel_menu_item_products (
    menu_item_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1, -- Cantidad de cada producto en el ítem de menú
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    PRIMARY KEY (menu_item_id, product_id), -- Clave compuesta para evitar duplicados
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- ### Menús
-- Colecciones de ítems de menú con precios o condiciones especiales, como "Menú del Día" o "Menú Infantil".
CREATE TABLE menus (
    id SERIAL PRIMARY KEY,
    restaurant_id INT NOT NULL, -- ID del restaurante al que pertenece el menú
    name VARCHAR(100) NOT NULL, -- Nombre del menú (ej. "Menú del Día")
    description TEXT,           -- Descripción del menú
    active_from TIME,           -- Hora de inicio de disponibilidad (ej. 12:00 para almuerzos)
    active_to TIME,             -- Hora de fin de disponibilidad (ej. 15:00)
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- ### Relación Menús - Ítems de Menú
-- Asocia ítems de menú a un menú específico (ej. un "Menú del Día" que incluye entrante, plato principal y postre).
CREATE TABLE rel_menus_menu_items (
    menu_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    PRIMARY KEY (menu_id, menu_item_id), -- Clave compuesta para evitar duplicados
    FOREIGN KEY (menu_id) REFERENCES menus(id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- ### Ítems de comanda
-- Productos específicos en una comanda.
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL, -- ID de la comanda
	menu_item_id INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL, -- Precio al momento de la comanda
    notes TEXT, -- Notas adicionales (ej. 'Sin cebolla')
    state order_item_state NOT NULL, -- Estado del ítem
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id)
);

-- ### Retroalimentación
-- Comentarios y calificaciones de los clientes sobre las comandas.
CREATE TABLE feedback (
    id SERIAL PRIMARY KEY,
    order_id INT NOT NULL, -- ID de la comanda
    rating INT, -- Calificación (1 a 5)
    comment TEXT, -- Comentario
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    CHECK (rating >= 1 AND rating <= 5), -- Restricción para calificación
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

-- ### Turnos
-- Horarios de trabajo para los empleados.
CREATE TABLE shifts (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL, -- Nombre del turno (ej. 'Turno Mañana')
    restaurant_id INT NOT NULL, -- ID del restaurante
    start_time TIME NOT NULL, -- Hora de inicio
    end_time TIME NOT NULL, -- Hora de fin
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(id)
);

-- ### Relación Usuarios-Turnos
-- Asignación de turnos a empleados.
CREATE TABLE rel_user_shifts (
    user_id INT NOT NULL,
    shift_id INT NOT NULL,
    shift_date DATE NOT NULL, -- Fecha del turno
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    deleted_at TIMESTAMP,
    PRIMARY KEY (user_id, shift_id, shift_date), -- Clave compuesta para evitar duplicados
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (shift_id) REFERENCES shifts(id)
);