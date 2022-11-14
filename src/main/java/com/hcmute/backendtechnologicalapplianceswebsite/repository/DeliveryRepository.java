package com.hcmute.backendtechnologicalapplianceswebsite.repository;

import com.hcmute.backendtechnologicalapplianceswebsite.model.Delivery;
import com.hcmute.backendtechnologicalapplianceswebsite.utils.MyUtils;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface DeliveryRepository extends JpaRepository<Delivery, String> {

    default String generateDeliveryId() {
        String PREFIX = "DL";
        int index = PREFIX.length();
        int length = 2;

        List<Delivery> deliveries = findAll();

        if (deliveries.size() == 0) {
            return PREFIX + "01"; // first delivery
        }

        deliveries.sort((c1, c2) -> {
            Long id1 = Long.parseLong(c1.getDeliveryId().substring(index));
            Long id2 = Long.parseLong(c2.getDeliveryId().substring(index));
            return id2.compareTo(id1);
        });

        String lastDeleveryId = deliveries.get(0).getDeliveryId();

        return MyUtils.generateID(PREFIX, length, lastDeleveryId);
    }
}