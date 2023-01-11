/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dbmsapp;

import java.beans.PropertyChangeListener;
import java.beans.PropertyChangeSupport;
import java.io.Serializable;
import java.math.BigDecimal;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Transient;

/**
 *
 * @author Admin
 */
@Entity
@Table(name = "STUDENT", catalog = "", schema = "HR")
@NamedQueries({
    @NamedQuery(name = "Student_1.findAll", query = "SELECT s FROM Student_1 s")
    , @NamedQuery(name = "Student_1.findByUsn", query = "SELECT s FROM Student_1 s WHERE s.usn = :usn")
    , @NamedQuery(name = "Student_1.findByName", query = "SELECT s FROM Student_1 s WHERE s.name = :name")
    , @NamedQuery(name = "Student_1.findByJob", query = "SELECT s FROM Student_1 s WHERE s.job = :job")
    , @NamedQuery(name = "Student_1.findBySalary", query = "SELECT s FROM Student_1 s WHERE s.salary = :salary")})
public class Student_1 implements Serializable {

    @Transient
    private PropertyChangeSupport changeSupport = new PropertyChangeSupport(this);

    private static final long serialVersionUID = 1L;
    @Id
    @Basic(optional = false)
    @Column(name = "USN")
    private Short usn;
    @Column(name = "NAME")
    private String name;
    @Column(name = "JOB")
    private String job;
    // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
    @Column(name = "SALARY")
    private BigDecimal salary;

    public Student_1() {
    }

    public Student_1(Short usn) {
        this.usn = usn;
    }

    public Short getUsn() {
        return usn;
    }

    public void setUsn(Short usn) {
        Short oldUsn = this.usn;
        this.usn = usn;
        changeSupport.firePropertyChange("usn", oldUsn, usn);
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        String oldName = this.name;
        this.name = name;
        changeSupport.firePropertyChange("name", oldName, name);
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        String oldJob = this.job;
        this.job = job;
        changeSupport.firePropertyChange("job", oldJob, job);
    }

    public BigDecimal getSalary() {
        return salary;
    }

    public void setSalary(BigDecimal salary) {
        BigDecimal oldSalary = this.salary;
        this.salary = salary;
        changeSupport.firePropertyChange("salary", oldSalary, salary);
    }

    @Override
    public int hashCode() {
        int hash = 0;
        hash += (usn != null ? usn.hashCode() : 0);
        return hash;
    }

    @Override
    public boolean equals(Object object) {
        // TODO: Warning - this method won't work in the case the id fields are not set
        if (!(object instanceof Student_1)) {
            return false;
        }
        Student_1 other = (Student_1) object;
        if ((this.usn == null && other.usn != null) || (this.usn != null && !this.usn.equals(other.usn))) {
            return false;
        }
        return true;
    }

    @Override
    public String toString() {
        return "dbmsapp.Student_1[ usn=" + usn + " ]";
    }

    public void addPropertyChangeListener(PropertyChangeListener listener) {
        changeSupport.addPropertyChangeListener(listener);
    }

    public void removePropertyChangeListener(PropertyChangeListener listener) {
        changeSupport.removePropertyChangeListener(listener);
    }
    
}
