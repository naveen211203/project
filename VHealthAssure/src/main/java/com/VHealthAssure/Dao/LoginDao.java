package com.VHealthAssure.Dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.VHealthAssure.Connection.MySqlInstance;
import com.VHealthAssure.Entity.LoginEntity;
import com.VHealthAssure.Entity.LoginResult;

public class LoginDao {

    private static final String USER_LOGIN_SQL =
        "SELECT UserId, FullName FROM users " +
        "WHERE (Email = ? OR Mobile = ?) " +
        "AND Password = ? AND Role = 'USER' AND Status = 'ACTIVE'";

    private static final String ADMIN_LOGIN_SQL =
        "SELECT AdminId, FullName FROM admins " +
        "WHERE (Email = ? OR Mobile = ?) " +
        "AND Password = ? AND Status = 'ACTIVE'";

    private static final String UPDATE_ADMIN_LAST_LOGIN =
        "UPDATE admins SET LastLogin = CURRENT_TIMESTAMP WHERE AdminId = ?";

    public LoginResult login(LoginEntity entity) throws Exception {

        try (Connection con = MySqlInstance.getinstance().getConnection()) {

            if ("ADMIN".equalsIgnoreCase(entity.getRole())) {

                PreparedStatement ps = con.prepareStatement(ADMIN_LOGIN_SQL);
                ps.setString(1, entity.getIdentifier());
                ps.setString(2, entity.getIdentifier());
                ps.setString(3, entity.getPassword());

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    String adminId = rs.getString("AdminId");

                    PreparedStatement upd = con.prepareStatement(UPDATE_ADMIN_LAST_LOGIN);
                    upd.setString(1, adminId);
                    upd.executeUpdate();

                    return new LoginResult(
                        adminId,
                        rs.getString("FullName"),
                        "ADMIN"
                    );
                }

            } else {

                PreparedStatement ps = con.prepareStatement(USER_LOGIN_SQL);
                ps.setString(1, entity.getIdentifier());
                ps.setString(2, entity.getIdentifier());
                ps.setString(3, entity.getPassword());

                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    return new LoginResult(
                        rs.getString("UserId"),
                        rs.getString("FullName"),
                        "USER"
                    );
                }
            }
        }
        return null;
    }
}
