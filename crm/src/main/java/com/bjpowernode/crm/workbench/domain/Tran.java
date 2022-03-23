package com.bjpowernode.crm.workbench.domain;

public class Tran {
    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String id;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.owner
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String owner;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.money
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String money;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.name
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String name;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.expected_date
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String expectedDate;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.customer_id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String customerId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.stage
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String stage;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.type
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String type;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.source
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String source;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.activity_id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String activityId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.contacts_id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String contactsId;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.create_by
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String createBy;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.create_time
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String createTime;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.edit_by
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String editBy;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.edit_time
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String editTime;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.description
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String description;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.contact_summary
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String contactSummary;

    /**
     * This field was generated by MyBatis Generator.
     * This field corresponds to the database column tbl_tran.next_contact_time
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    private String nextContactTime;

    //扩展属性
    private String possibility;

    private String orderNo;

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo;
    }

    public String getPossibility() {
        return possibility;
    }

    public void setPossibility(String possibility) {
        this.possibility = possibility;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.id
     *
     * @return the value of tbl_tran.id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getId() {
        return id;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.id
     *
     * @param id the value for tbl_tran.id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setId(String id) {
        this.id = id == null ? null : id.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.owner
     *
     * @return the value of tbl_tran.owner
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getOwner() {
        return owner;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.owner
     *
     * @param owner the value for tbl_tran.owner
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setOwner(String owner) {
        this.owner = owner == null ? null : owner.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.money
     *
     * @return the value of tbl_tran.money
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getMoney() {
        return money;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.money
     *
     * @param money the value for tbl_tran.money
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setMoney(String money) {
        this.money = money == null ? null : money.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.name
     *
     * @return the value of tbl_tran.name
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getName() {
        return name;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.name
     *
     * @param name the value for tbl_tran.name
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.expected_date
     *
     * @return the value of tbl_tran.expected_date
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getExpectedDate() {
        return expectedDate;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.expected_date
     *
     * @param expectedDate the value for tbl_tran.expected_date
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setExpectedDate(String expectedDate) {
        this.expectedDate = expectedDate == null ? null : expectedDate.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.customer_id
     *
     * @return the value of tbl_tran.customer_id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getCustomerId() {
        return customerId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.customer_id
     *
     * @param customerId the value for tbl_tran.customer_id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setCustomerId(String customerId) {
        this.customerId = customerId == null ? null : customerId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.stage
     *
     * @return the value of tbl_tran.stage
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getStage() {
        return stage;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.stage
     *
     * @param stage the value for tbl_tran.stage
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setStage(String stage) {
        this.stage = stage == null ? null : stage.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.type
     *
     * @return the value of tbl_tran.type
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getType() {
        return type;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.type
     *
     * @param type the value for tbl_tran.type
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setType(String type) {
        this.type = type == null ? null : type.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.source
     *
     * @return the value of tbl_tran.source
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getSource() {
        return source;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.source
     *
     * @param source the value for tbl_tran.source
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setSource(String source) {
        this.source = source == null ? null : source.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.activity_id
     *
     * @return the value of tbl_tran.activity_id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getActivityId() {
        return activityId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.activity_id
     *
     * @param activityId the value for tbl_tran.activity_id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setActivityId(String activityId) {
        this.activityId = activityId == null ? null : activityId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.contacts_id
     *
     * @return the value of tbl_tran.contacts_id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getContactsId() {
        return contactsId;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.contacts_id
     *
     * @param contactsId the value for tbl_tran.contacts_id
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setContactsId(String contactsId) {
        this.contactsId = contactsId == null ? null : contactsId.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.create_by
     *
     * @return the value of tbl_tran.create_by
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getCreateBy() {
        return createBy;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.create_by
     *
     * @param createBy the value for tbl_tran.create_by
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setCreateBy(String createBy) {
        this.createBy = createBy == null ? null : createBy.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.create_time
     *
     * @return the value of tbl_tran.create_time
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getCreateTime() {
        return createTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.create_time
     *
     * @param createTime the value for tbl_tran.create_time
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setCreateTime(String createTime) {
        this.createTime = createTime == null ? null : createTime.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.edit_by
     *
     * @return the value of tbl_tran.edit_by
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getEditBy() {
        return editBy;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.edit_by
     *
     * @param editBy the value for tbl_tran.edit_by
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setEditBy(String editBy) {
        this.editBy = editBy == null ? null : editBy.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.edit_time
     *
     * @return the value of tbl_tran.edit_time
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getEditTime() {
        return editTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.edit_time
     *
     * @param editTime the value for tbl_tran.edit_time
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setEditTime(String editTime) {
        this.editTime = editTime == null ? null : editTime.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.description
     *
     * @return the value of tbl_tran.description
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getDescription() {
        return description;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.description
     *
     * @param description the value for tbl_tran.description
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setDescription(String description) {
        this.description = description == null ? null : description.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.contact_summary
     *
     * @return the value of tbl_tran.contact_summary
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getContactSummary() {
        return contactSummary;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.contact_summary
     *
     * @param contactSummary the value for tbl_tran.contact_summary
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setContactSummary(String contactSummary) {
        this.contactSummary = contactSummary == null ? null : contactSummary.trim();
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method returns the value of the database column tbl_tran.next_contact_time
     *
     * @return the value of tbl_tran.next_contact_time
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public String getNextContactTime() {
        return nextContactTime;
    }

    /**
     * This method was generated by MyBatis Generator.
     * This method sets the value of the database column tbl_tran.next_contact_time
     *
     * @param nextContactTime the value for tbl_tran.next_contact_time
     *
     * @mbggenerated Sat Mar 12 17:16:17 CST 2022
     */
    public void setNextContactTime(String nextContactTime) {
        this.nextContactTime = nextContactTime == null ? null : nextContactTime.trim();
    }
}