package com.bjpowernode.crm.workbench.mapper;

import com.bjpowernode.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerMapper {

    /**
     * 保存创建的客户
     */
    int insertCustomer(Customer customer);

    /**
     * 查询所有的客户名称, 模糊查询
     */
    List<String> queryCustomerNameByName(String name);

    /**
     * 根据名称精确查询客户
     */
    Customer selectCustomerByName(String name);

}