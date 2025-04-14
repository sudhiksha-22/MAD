import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting (add intl package to pubspec.yaml)

void main() {
  runApp(const SimpleCrmApp());
}

class SimpleCrmApp extends StatelessWidget {
  const SimpleCrmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple CRM',
      theme: ThemeData(
        primarySwatch:
            Colors.blueGrey, // Use primary swatch for theme consistency
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Optional: Define app-wide text themes, button themes etc.
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueGrey,
          foregroundColor: Colors.white, // Title/icon color
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.teal,
        ),
        chipTheme: ChipThemeData(
          padding: const EdgeInsets.all(2.0),
          labelStyle: const TextStyle(
              fontSize: 12, color: Colors.white), // Default chip text color
          secondaryLabelStyle: const TextStyle(
              fontSize: 12, color: Colors.white), // Used by default Chip widget
          brightness:
              Brightness.dark, // Ensures white text is visible on colored chips
        ),
      ),
      home: const CustomerListScreen(), // Start with the customer list
      debugShowCheckedModeBanner: false, // Hide the debug banner
    );
  }
}

class Customer {
  final String id;
  final String name;
  final String email;
  final String address;
  final String contact;
  final List<Order>
      orders; // List itself is final, but its contents (Orders) can change status

  const Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.address,
    required this.contact,
    required this.orders,
  });
}

class Order {
  final String id;
  final String product;
  String status; // Status can change, so not final
  final DateTime orderDate;

  Order({
    required this.id,
    required this.product,
    required this.status,
    required this.orderDate,
  });
}

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  // --- Static Data ---
  // In a real app, this would come from a database.
  // We manage this list in the state so we can add new customers.
  final List<Customer> _customers = [
    Customer(
      id: 'C001',
      name: 'Alice Wonderland',
      email: 'alice@example.com',
      address: '123 Fantasy Lane',
      contact: '555-1234',
      orders: [
        Order(
            id: 'O1001',
            product: 'Magic Potion',
            status: 'Shipped',
            orderDate: DateTime(2024, 1, 10)),
        Order(
            id: 'O1002',
            product: 'Talking Flowers Seeds',
            status: 'Processing',
            orderDate: DateTime(2024, 1, 15)),
      ],
    ),
    Customer(
      id: 'C002',
      name: 'Bob The Builder',
      email: 'bob@example.com',
      address: '456 Construction St',
      contact: '555-5678',
      orders: [
        Order(
            id: 'O2001',
            product: 'Hammer',
            status: 'Delivered',
            orderDate: DateTime(2024, 1, 5)),
        Order(
            id: 'O2002',
            product: 'Wrench Set',
            status: 'Pending',
            orderDate: DateTime(2024, 1, 20)),
      ],
    ),
    Customer(
      id: 'C003',
      name: 'Charlie Chaplin',
      email: 'charlie@example.com',
      address: '789 Silent Film Ave',
      contact: '555-9012',
      orders: [], // No orders initially
    ),
  ];
  // --- End Static Data ---

  // Function to add a new customer to the list
  void _addCustomer(Customer customer) {
    setState(() {
      _customers.add(customer);
    });
  }

  // Function to navigate to registration screen
  void _navigateRegister() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterCustomerScreen(
          onRegister: _addCustomer, // Pass the callback function
        ),
      ),
    );
  }

  // Function to navigate to detail screen
  void _navigateDetails(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailScreen(customer: customer),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: _customers.length,
        itemBuilder: (context, index) {
          final customer = _customers[index];
          return ListTile(
            title: Text(customer.name),
            subtitle: Text(customer.email),
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(customer.name.isNotEmpty ? customer.name[0] : '?',
                  style: const TextStyle(color: Colors.white)),
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () => _navigateDetails(customer),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateRegister,
        tooltip: 'Register New Customer',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;
  const CustomerDetailScreen({required this.customer, super.key});

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  final List<String> _orderStatuses = [
    'Pending',
    'Processing',
    'Shipped',
    'Delivered',
    'Cancelled'
  ];

  void _updateOrderStatus(Order order) {
    setState(() {
      int currentIndex = _orderStatuses.indexOf(order.status);
      int nextIndex = (currentIndex + 1) % _orderStatuses.length;
      order.status = _orderStatuses[nextIndex];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order ${order.id} status updated to ${order.status}'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customer.name),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer Details',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${widget.customer.id}'),
                    Text('Email: ${widget.customer.email}'),
                    Text('Contact: ${widget.customer.contact}'),
                    Text('Address: ${widget.customer.address}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text('Orders', style: Theme.of(context).textTheme.titleLarge),
            const Divider(),
            Expanded(
              child: widget.customer.orders.isEmpty
                  ? const Center(
                      child: Text('No orders found for this customer.'))
                  : ListView.builder(
                      itemCount: widget.customer.orders.length,
                      itemBuilder: (context, index) {
                        final order = widget.customer.orders[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          child: ListTile(
                            title: Text(
                                'Order ID: ${order.id} - ${order.product}'),
                            subtitle: Text(
                                'Date: ${dateFormatter.format(order.orderDate)}\nStatus: ${order.status}'),
                            isThreeLine: true,
                            trailing: Chip(
                              label: Text(order.status),
                              backgroundColor: _getStatusColor(order.status),
                              labelStyle: const TextStyle(color: Colors.white),
                            ),
                            onTap: () => _updateOrderStatus(order),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Processing':
        return Colors.blue;
      case 'Shipped':
        return Colors.green;
      case 'Delivered':
        return Colors.teal;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class RegisterCustomerScreen extends StatefulWidget {
  final Function(Customer) onRegister;

  const RegisterCustomerScreen({required this.onRegister, super.key});

  @override
  State<RegisterCustomerScreen> createState() => _RegisterCustomerScreenState();
}

class _RegisterCustomerScreenState extends State<RegisterCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newId =
          'C${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
      final newCustomer = Customer(
        id: newId,
        name: _nameController.text,
        email: _emailController.text,
        address: _addressController.text,
        contact: _contactController.text,
        orders: [],
      );
      widget.onRegister(newCustomer);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${newCustomer.name} registered successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Customer'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a name'
                    : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value == null || value.isEmpty || !value.contains('@')
                        ? 'Please enter a valid email'
                        : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter an address'
                    : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a contact number'
                    : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
