class CatRentalRequest < ActiveRecord::Base
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validate :no_overlapping_approved_requests

  belongs_to :cat

  after_initialize { self.status ||= "PENDING" }

  private

  def no_overlapping_approved_requests
    unless overlapping_approved_requests.empty?
      errors[:cat_rental_request] << 'overlapping cat rental request'
    end
  end

  def overlapping_requests
    where_string = <<-SQL
        :start_date BETWEEN
          cat_rental_requests.start_date
          AND cat_rental_requests.end_date
      OR
        :end_date BETWEEN
          cat_rental_requests.start_date
          AND cat_rental_requests.end_date
      OR
        cat_rental_requests.start_date BETWEEN
          :start_date
          AND :end_date
      OR
        cat_rental_requests.end_date BETWEEN
          :start_date
          AND :end_date
      AND
        cat_rental_requests.id != :id
    SQL

    where_string
    CatRentalRequest
      .where(where_string,
        id: self.id,
        start_date: self.start_date,
        end_date: self.end_date
      )    # will return duplicates

  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end

end
