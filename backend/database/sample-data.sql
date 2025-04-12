-- Script de datos de prueba para Gastro & Hub

-- 1. Unidades de medida (mt_units)
INSERT INTO mt_units (name, symbol) VALUES
('Kilogramo', 'kg'),
('Litro', 'L'),
('Unidad', 'u');

-- 2. Roles (mt_roles)
INSERT INTO mt_roles (name, description) VALUES
('dueño', 'Dueño del restaurante'),
('camarero', 'Camarero del restaurante'),
('cocinero', 'Cocinero del restaurante');

-- 3. Usuarios (users)
-- Nota: Para password_hash, usamos un valor placeholder. En producción, usa un hash real (ej. bcrypt).
INSERT INTO users (name, email, password_hash, role_id, phone, status) VALUES
('Juan Pérez', 'juan@example.com', 'hashed_password_1', 1, '123456789', 'active'),  -- Dueño
('Ana Gómez', 'ana@example.com', 'hashed_password_2', 2, '987654321', 'active');  -- Camarero

-- 4. Restaurantes (restaurants)
-- Asociamos el restaurante al dueño (usuario con id=1)
INSERT INTO restaurants (name, owner_id, address, cuisine_type, opening_hours, active) VALUES
('Restaurante Prueba', 1, 'Calle Falsa 123', 'Italiana', '{"monday": {"open": "09:00", "close": "22:00"}}', TRUE);

-- 5. Diseños (layouts)
-- Asociamos el diseño al restaurante (id=1)
INSERT INTO layouts (restaurant_id, name, description) VALUES
(1, 'Sala Principal', 'Diseño de la sala principal del restaurante');

-- 6. Mesas (tables)
-- Asociamos las mesas al diseño (id=1)
INSERT INTO tables (layout_id, number, state, capacity) VALUES
(1, 1, 'available', 4),
(1, 2, 'available', 2),
(1, 3, 'available', 6);

-- 7. Categorías de menú (menu_categories)
-- Asociamos las categorías al restaurante (id=1)
INSERT INTO menu_categories (restaurant_id, name, description, available) VALUES
(1, 'Entrantes', 'Platos para empezar', TRUE),
(1, 'Platos Principales', 'Platos fuertes', TRUE),
(1, 'Postres', 'Dulces y postres', TRUE);

-- 8. Ítems de menú (menu_items)
-- Asociamos los ítems a las categorías (ids=1,2,3)
INSERT INTO menu_items (category_id, name, price) VALUES
(1, 'Ensalada César', 8.50),
(1, 'Bruschetta', 6.00),
(2, 'Pizza Margarita', 12.00),
(2, 'Pasta Carbonara', 14.00),
(3, 'Tiramisú', 5.00),
(3, 'Helado', 3.50);