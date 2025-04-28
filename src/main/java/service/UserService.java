package service;

import daos.UserDao;
import model.users.User;

public class UserService {

    private UserDao userDao;

    public UserService() {
        this.userDao = new UserDao();
    }

    // need to test and put validation to this method
    public void registerUser(User user){
        userDao.insertUser(user);
    }

    // we can add another methods here for...
    // login
    // update profile
    // delete account
    // and others
}
