package service;

import daos.UserDao;
import model.users.User;

import java.util.List;

public class UserService {

    private UserDao userDao;

    public UserService() {
        this.userDao = new UserDao();
    }

    // need to test and put validation to this method
    public void registerUser(User user){
        userDao.insertUser(user);
    }


    // method to login
    public User userLogin(String email, String password){
        User user = userDao.findByEmail(email);

        if (user == null){
            throw new RuntimeException("wrong user email, try again" + email);
        }

        if (!user.getPassword().equals(password)){
            throw new RuntimeException("Worng password. try again");
        }

        return user;

    }

    public User findUserByEmail(String email) {
        return new UserDao().findByEmail(email);
    }

    public List<User> getAllUsers() {
        return userDao.getAllUsers();
    }

    public void updateUser(User user) {
        userDao.updateUser(user);
    }
    public void deleteUser(Long id) {
        userDao.deleteUser(id);
    }

    // we can add another methods here for...
    // login
    // update profile
    // delete account
    // and others

}