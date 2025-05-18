package service;

import daos.UserDao;
import model.users.User;
import org.mindrot.jbcrypt.BCrypt;

import java.util.List;

public class UserService {

    private UserDao userDao;

    public UserService() {
        this.userDao = new UserDao();
    }

    // need to test and put validation to this method
    public void registerUser(User user){
        // hash the password for security.
        String hashPassword = BCrypt.hashpw(user.getPassword(), BCrypt.gensalt());
        user.setPassword(hashPassword);

        userDao.insertUser(user);
    }


    // method to login
    public User userLogin(String email, String password){
        User user = userDao.findByEmail(email);

        if (user == null){
            throw new RuntimeException("wrong user email, try again" + email);
        }

        // this block read plain text PW from the db
//        if (!user.getPassword().equals(password)){
//            throw new RuntimeException("Wrong password. try again");
//        }

        // this will block of code will check if the hashed PW match the one in the db
        if (!BCrypt.checkpw(password, user.getPassword())){
            throw new RuntimeException("Wrong password. try again");
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