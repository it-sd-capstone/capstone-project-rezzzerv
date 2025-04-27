package edu.cvtc.rezzzerv.service;

import edu.cvtc.rezzzerv.daos.UserDao;
import edu.cvtc.rezzzerv.model.users.User;

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
