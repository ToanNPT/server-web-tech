package com.hcmute.backendtechnologicalapplianceswebsite.repository;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Order;
import com.hcmute.backendtechnologicalapplianceswebsite.model.User;
import com.hcmute.backendtechnologicalapplianceswebsite.utils.MyUtils;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface OrderRepository extends JpaRepository<Order, String> {
    Order findByOrderId(String id);

    default String generateOrderId() {
        String PREFIX = "O";
        int index = PREFIX.length();
        int length = 5;

        List<Order> orders = findAll();

        if (orders.size() == 0) {
            return PREFIX + "00001"; // first order
        }

        orders.sort((c1, c2) -> {
            Long id1 = Long.parseLong(c1.getOrderId().substring(index));
            Long id2 = Long.parseLong(c2.getOrderId().substring(index));
            return id2.compareTo(id1);
        });

        String lastOrderId = orders.get(0).getOrderId();

        return MyUtils.generateID(PREFIX, length, lastOrderId);
    }

    Iterable<Order> findAllByUser(User user);
}