CREATE DATABASE PhoneShop;
GO

USE PhoneShop;
GO

-- Customer Table
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY IDENTITY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    password VARCHAR(100),
    address VARCHAR(255),
    phone_number VARCHAR(20)
);

-- Category Table (For Phone Brands)
CREATE TABLE Category (
    category_id INT PRIMARY KEY IDENTITY,
    name VARCHAR(100) NOT NULL
);

-- Product Table (Mobile Phones)
CREATE TABLE [Product] (
    product_id INT PRIMARY KEY IDENTITY,
    model VARCHAR(100) UNIQUE,
    description TEXT,
    price DECIMAL(10,2),
    stock INT,
    category_id INT FOREIGN KEY REFERENCES Category(category_id)
);

-- Cart Table
CREATE TABLE Cart (
    cart_id INT PRIMARY KEY IDENTITY,
    quantity INT,
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    product_id INT FOREIGN KEY REFERENCES Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Wishlist Table
CREATE TABLE Wishlist (
    wishlist_id INT PRIMARY KEY IDENTITY,
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
    product_id INT FOREIGN KEY REFERENCES Product(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Payment Table
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY IDENTITY,
    payment_date DATETIME DEFAULT GETDATE(),
    payment_method VARCHAR(100),
    amount DECIMAL(10,2),
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id) ON DELETE CASCADE
);

-- Shipment Table
CREATE TABLE Shipment (
    shipment_id INT PRIMARY KEY IDENTITY,
    shipment_date DATETIME DEFAULT GETDATE(),
    address VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(50),
    country VARCHAR(50),
    zip_code VARCHAR(10),
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id)
);

-- Order Table
CREATE TABLE [Order] (
    order_id INT PRIMARY KEY IDENTITY,
    order_date DATETIME DEFAULT GETDATE(),
    total_price DECIMAL(10,2),
    customer_id INT FOREIGN KEY REFERENCES Customer(customer_id)
);

-- Order_Payment Table (To Fix Multiple Cascade Paths)
CREATE TABLE Order_Payment (
    order_id INT NOT NULL,
    payment_id INT NOT NULL,
	PRIMARY KEY (order_id, payment_id),
    FOREIGN KEY (order_id) REFERENCES [Order](order_id) ON DELETE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES Payment(payment_id) ON DELETE CASCADE
);

-- Order_Shipment Table (To Fix Multiple Cascade Paths)
CREATE TABLE Order_Shipment (
    order_id INT NOT NULL,
    shipment_id INT NOT NULL,
    PRIMARY KEY (order_id, shipment_id),
    FOREIGN KEY (order_id) REFERENCES [Order](order_id) ON DELETE CASCADE,
    FOREIGN KEY (shipment_id) REFERENCES Shipment(shipment_id) ON DELETE CASCADE
);

-- Order_Item Table
CREATE TABLE Order_Item (
    order_item_id INT PRIMARY KEY IDENTITY,
    quantity INT,
    price DECIMAL(10,2),
    product_id INT FOREIGN KEY REFERENCES Product(product_id) ON DELETE CASCADE,
    order_id INT FOREIGN KEY REFERENCES [Order](order_id) ON DELETE CASCADE
);
