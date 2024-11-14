// See https://aka.ms/new-console-templ
using System;
using System.Collections.Generic;

namespace CustomerOrderTracking
{
    // Class to represent an Address
    public class Address
    {
        public string Street { get; set; }
        public string City { get; set; }
        public string State { get; set; }
        public string ZipCode { get; set; }

        public Address(string street, string city, string state, string zipCode)
        {
            Street = street;
            City = city;
            State = state;
            ZipCode = zipCode;
        }

        public override string ToString()
        {
            return $"{Street}, {City}, {State} {ZipCode}";
        }
    }

    // Class to represent an Order
    public class Order
    {
        public int OrderId { get; set; }
        public DateTime OrderDate { get; set; }
        public string Product { get; set; }
        public decimal Price { get; set; }

        public Order(int orderId, DateTime orderDate, string product, decimal price)
        {
            OrderId = orderId;
            OrderDate = orderDate;
            Product = product;
            Price = price;
        }

        public override string ToString()
        {
            return $"Order ID: {OrderId}, Date: {OrderDate.ToShortDateString()}, Product: {Product}, Price: ${Price}";
        }
    }

    // Class to represent a Customer
    public class Customer
    {
        public int CustomerId { get; set; }
        public string Name { get; set; }
        public Address Address { get; set; }
        public List<Order> Orders { get; set; }

        public Customer(int customerId, string name, Address address)
        {
            CustomerId = customerId;
            Name = name;
            Address = address;
            Orders = new List<Order>();
        }

        public void AddOrder(Order order)
        {
            Orders.Add(order);
        }

        public void DisplayCustomerInfo()
        {
            Console.WriteLine($"Customer ID: {CustomerId}");
            Console.WriteLine($"Name: {Name}");
            Console.WriteLine($"Address: {Address}");
            Console.WriteLine("Orders:");
            foreach (var order in Orders)
            {
                Console.WriteLine($" - {order}");
            }
            Console.WriteLine();
        }
    }

    // Main Program
    class Program
    {
        static void Main(string[] args)
        {
            // Creating some addresses
            Address address1 = new Address("123 Maple St", "Springfield", "IL", "62704");
            Address address2 = new Address("456 Oak St", "Columbus", "OH", "43215");

            // Creating customers
            Customer customer1 = new Customer(1, "John Doe", address1);
            Customer customer2 = new Customer(2, "Jane Smith", address2);

            // Creating orders and adding to customers
            Order order1 = new Order(101, DateTime.Now, "Laptop", 1200.99m);
            Order order2 = new Order(102, DateTime.Now, "Smartphone", 799.49m);

            customer1.AddOrder(order1);
            customer1.AddOrder(order2);

            // Displaying information
            customer1.DisplayCustomerInfo();
            customer2.DisplayCustomerInfo();
        }
    }
}
