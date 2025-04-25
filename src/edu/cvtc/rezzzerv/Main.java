package edu.cvtc.rezzzerv;

import edu.cvtc.rezzzerv.daos.UserDao;
import edu.cvtc.rezzzerv.model.users.Administrator;
import edu.cvtc.rezzzerv.model.users.Customer;
import edu.cvtc.rezzzerv.model.users.User;

import java.util.Scanner;

public class Main {

    public static void main(String[] args) {
      System.out.println("Hello, world! Server would start here.");

       //Testing CRUD for User

        UserDao userDao = new UserDao();
        Scanner sc = new Scanner(System.in);
        boolean exit = false;

        while (!exit){
            System.out.println("\n=== Hotel CRUD Test ===");
            System.out.println("1. Register Customer");
            System.out.println("2. List all Users:");
            System.out.println("3. Get user by Id");
            System.out.println("4. update user");
            System.out.println("5. Delete user");
            System.out.println("6. search  user by email");

            System.out.print("Choose an option: ");

            int option = sc.nextInt();
            sc.nextLine();

            switch (option){
                case 1:
                    System.out.print("Name: ");
                    String name = sc.nextLine();
                    System.out.print("Last Name: ");
                    String last = sc.nextLine();
                    System.out.print("Phone: ");
                    String phone = sc.nextLine();
                    System.out.print("Email: ");
                    String email = sc.nextLine();
                    System.out.print("Password: ");
                    String pwd = sc.nextLine();
                    Customer cust = new Customer(null, name, last, phone, email, pwd, null);
                    userDao.insertUser(cust);
                    System.out.println("Customer registered.");
                    break;
                case 2:
                    System.out.println(userDao.getAllUsers());
                    break;
                case 3:
                    System.out.println("insert the user id you looking for");
                    Long Id = sc.nextLong();
                    System.out.println(userDao.getUserById(Id));
                    break;
                case 4:
                    System.out.println("insert the id of user to update");
                    Long id = Long.parseLong(sc.nextLine());
                    System.out.println("insert user new name");
                    String nameUser = sc.nextLine();
                    System.out.println("insert new last name");
                    String lastName = sc.nextLine();
                    System.out.println("insert new Phone");
                    String phoneUser = sc.nextLine();
                    System.out.println("insert new Email");
                    String emailUser = sc.nextLine();
                    System.out.println("insert new password");
                    String psw = sc.nextLine();
                    System.out.println("insert type of User( Customer or Administrator");
                    String userType = sc.nextLine();

                    User userToUpdate = null;

                    if (userType.equalsIgnoreCase("Administrator")) {
                        userToUpdate = new Administrator();
                    } else if (userType.equalsIgnoreCase("Customer")) {
                        userToUpdate = new Customer();
                    }

                    if (userToUpdate != null) {
                        userToUpdate.setId(id);
                        userToUpdate.setName(nameUser);
                        userToUpdate.setLastName(lastName);
                        userToUpdate.setPhone(phoneUser);
                        userToUpdate.setEmail(emailUser);
                        userToUpdate.setPassword(psw);
                        userDao.updateUser(userToUpdate);
                        System.out.println("User updated successfully.");
                    } else {
                        System.out.println("Invalid user type. Please enter 'Customer' or 'Administrator'.");
                    }
                    break;
                case 5:
                    System.out.println("insert Id of user to delete");
                    Long idToDelete = Long.parseLong(sc.nextLine());
                    User userToDelete = userDao.getUserById(idToDelete);
                    if (userToDelete != null) {
                        userDao.deleteUser(idToDelete);
                        System.out.println("User eliminated");
                    } else {
                        System.out.println("User with ID " + idToDelete + " not found.");
                    }
                    break;
                case 6:
                    System.out.println("Insert user email to search:");
                    String emailInput = sc.nextLine();

                    User user3 = userDao.findByEmail(emailInput);
                    if (user3 != null) {
                        System.out.println("User found:");
                        System.out.println("ID: " + user3.getId());
                        System.out.println("Name: " + user3.getName());
                        System.out.println("Email: " + user3.getEmail());
                        System.out.println("User Type: " + (user3 instanceof Administrator ? "Administrator" : "Customer"));
                    } else {
                        System.out.println("No user found with that email.");
                    }
                    break;
                case 0:
                    exit = true;
                    break;
                default:
                    System.out.println("Invalid option.");
            }
        }

    }

}
