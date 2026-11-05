package com.VHealthAssure.Controller;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.VHealthAssure.Dao.AdminHospitalsDao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AdminHospitals")
public class AdminHospitalsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AdminHospitalsDao hospitalDao;

    @Override
    public void init() {
        hospitalDao = new AdminHospitalsDao();
    }

    private boolean isAdmin(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loginId") == null ||
            !"ADMIN".equals(session.getAttribute("role"))) {

            response.sendRedirect(request.getContextPath() + "/login.html");
            return false;
        }

        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        String search = request.getParameter("search");
        String status = request.getParameter("status");

        if (search == null) {
            search = "";
        }

        if (status == null || status.trim().isEmpty()) {
            status = "ALL";
        }

        if (!"ALL".equals(status) &&
            !"ACTIVE".equals(status) &&
            !"INACTIVE".equals(status)) {
            status = "ALL";
        }

        List<Map<String, Object>> hospitals =
                hospitalDao.getAllHospitals(search, status);

        Map<String, Integer> statistics =
                hospitalDao.getHospitalStatistics();

        HttpSession session = request.getSession(false);

        String adminName = (String) session.getAttribute("userName");

        if (adminName == null || adminName.trim().isEmpty()) {
            adminName = "Administrator";
        }

        request.setAttribute("hospitals", hospitals);
        request.setAttribute("statistics", statistics);
        request.setAttribute("search", search);
        request.setAttribute("selectedStatus", status);
        request.setAttribute("adminName", adminName);

        request.getRequestDispatcher(
            "/WEB-INF/admin/AdminHospitals.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request, response)) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String contextPath = request.getContextPath();

        if (action == null) {
            response.sendRedirect(contextPath + "/AdminHospitals?message=invalidAction");
            return;
        }

        // Add hospital
        if ("add".equals(action)) {

            Map<String, String> hospital = getHospitalData(request);

            if (!isValidHospital(hospital)) {
                response.sendRedirect(contextPath + "/AdminHospitals?message=invalidData");
                return;
            }

            boolean added = hospitalDao.addHospital(hospital);

            response.sendRedirect(
                contextPath + "/AdminHospitals?message=" +
                (added ? "added" : "notAdded")
            );

            return;
        }

        // Update hospital
        if ("update".equals(action)) {

            int hospitalId = parseHospitalId(request.getParameter("hospitalId"));

            if (hospitalId <= 0) {
                response.sendRedirect(contextPath + "/AdminHospitals?message=invalidId");
                return;
            }

            Map<String, String> hospital = getHospitalData(request);

            if (!isValidHospital(hospital)) {
                response.sendRedirect(contextPath + "/AdminHospitals?message=invalidData");
                return;
            }

            boolean updated =
                    hospitalDao.updateHospital(hospitalId, hospital);

            response.sendRedirect(
                contextPath + "/AdminHospitals?message=" +
                (updated ? "updated" : "notUpdated")
            );

            return;
        }
        
        // Delete hospital
        if ("delete".equals(action)) {

            int hospitalId =
                    parseHospitalId(request.getParameter("hospitalId"));

            if (hospitalId <= 0) {
                response.sendRedirect(
                    contextPath + "/AdminHospitals?message=invalidId"
                );
                return;
            }

            boolean deleted = hospitalDao.deleteHospital(hospitalId);

            response.sendRedirect(
                contextPath + "/AdminHospitals?message=" +
                (deleted ? "deleted" : "notDeleted")
            );

            return;
        }

        // Activate or deactivate hospital
        if ("status".equals(action)) {

            int hospitalId = parseHospitalId(request.getParameter("hospitalId"));
            String status = request.getParameter("status");

            if (hospitalId <= 0 ||
                (!"ACTIVE".equals(status) && !"INACTIVE".equals(status))) {

                response.sendRedirect(contextPath + "/AdminHospitals?message=invalidData");
                return;
            }

            boolean updated =
                    hospitalDao.updateHospitalStatus(hospitalId, status);

            response.sendRedirect(
                contextPath + "/AdminHospitals?message=" +
                (updated ? "statusUpdated" : "notUpdated")
            );

            return;
        }

        response.sendRedirect(contextPath + "/AdminHospitals?message=invalidAction");
    }

    private Map<String, String> getHospitalData(HttpServletRequest request) {

        Map<String, String> hospital = new HashMap<>();

        hospital.put("hospitalName", clean(request.getParameter("hospitalName")));
        hospital.put("address", clean(request.getParameter("address")));
        hospital.put("city", clean(request.getParameter("city")));
        hospital.put("state", clean(request.getParameter("state")));
        hospital.put("contactNumber", clean(request.getParameter("contactNumber")));
        hospital.put("email", clean(request.getParameter("email")));

        String status = request.getParameter("networkStatus");

        if (status == null || status.trim().isEmpty()) {
            status = "ACTIVE";
        }

        hospital.put("networkStatus", status.trim());

        return hospital;
    }

    private boolean isValidHospital(Map<String, String> hospital) {

        String name = hospital.get("hospitalName");
        String address = hospital.get("address");
        String city = hospital.get("city");
        String state = hospital.get("state");
        String contact = hospital.get("contactNumber");
        String email = hospital.get("email");
        String status = hospital.get("networkStatus");

        if (name == null || name.isEmpty() || name.length() > 150 ||
            address == null || address.isEmpty() || address.length() > 255 ||
            city == null || city.isEmpty() || city.length() > 100 ||
            state == null || state.isEmpty() || state.length() > 100) {
            return false;
        }

        if (contact != null && !contact.isEmpty() && contact.length() > 20) {
            return false;
        }

        if (email != null && !email.isEmpty() && email.length() > 150) {
            return false;
        }

        return "ACTIVE".equals(status) || "INACTIVE".equals(status);
    }

    private String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private int parseHospitalId(String value) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return -1;
        }
    }
}