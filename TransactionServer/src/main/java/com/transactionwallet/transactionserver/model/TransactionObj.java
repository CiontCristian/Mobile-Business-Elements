package com.transactionwallet.transactionserver.model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Entity
public class TransactionObj {
    @Id
    private Integer id;
    private String recipient;
    private Double amount;
    private String currency;
}
