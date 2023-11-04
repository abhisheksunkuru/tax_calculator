class Employee < ApplicationRecord
  validates :first_name,:last_name, :doj, :eid, presence: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :salary, presence: true, numericality: { greater_than: 0 }
  validates_uniqueness_of :eid
  validates_associated :phone_numbers

  has_many :phone_numbers, dependent: :destroy

  accepts_nested_attributes_for :phone_numbers

  def calculate_no_of_months_days
    tds_start_date, tds_end_date = financial_year_range
    # if tds_start_date > financial_year_start

    # end
    # Calculate the difference in months and days
    total_months = (tds_end_date.year - tds_start_date.year) * 12 + (tds_end_date.month - tds_start_date.month)
    total_days = tds_end_date.day - tds_start_date.day

    # If the day of the end date is less than the day of the start date, adjust the months and days
    if total_days < 0
      total_months -= 1
      total_days += 30  # Assuming 30 days in a month for simplicity
    end

    if total_days == 30 || total_days == 29
      total_days = 0
      total_months += 1
    end
    # Determine the number of months and days
    months = total_months
    days = total_days

    return days, months
  end

  def salary_for_fy
    days, months = calculate_no_of_months_days
    salary_per_day = salary.to_f/30
    (12*salary) + (salary_per_day*days)
  end

  def tax_calculation
    income = salary_for_fy
    if income <= 250000
      tax = 0
    elsif income <= 500000
      tax = (income - 250000) * 0.05
    elsif income <= 1000000
      tax = (250000 * 0.05) + ((income - 500000) * 0.10)
    else
      tax = (250000 * 0.05) + (500000 * 0.10) + ((income - 1000000) * 0.20)
    end

    tax
  end

  def cess
    income = salary_for_fy
    income > 2500000 ? ((income-2500000) * 0.02) : 0
  end

  def financial_year_range
    current_date = Date.today
    # Determine the financial year start and end dates
    if current_date.month >= 4
      # If the current month is April or later, the financial year started in the current year.
      financial_year_start = Date.new(current_date.year, 4, 1)
      financial_year_end = Date.new(current_date.year + 1, 3, 31)
    else
      # If the current month is earlier than April, the financial year started in the previous year.
      financial_year_start = Date.new(current_date.year - 1, 4, 1)
      financial_year_end = Date.new(current_date.year, 3, 31)
    end
    if doj > financial_year_start
      financial_year_start = doj
    end

    return financial_year_start, financial_year_end
  end
end
