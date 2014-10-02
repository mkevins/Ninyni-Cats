class CatRentalRequest < ActiveRecord::Base
  validates :cat, :leasee, :start_date, :end_date, :status, presence: true
  validate :no_overlapping_approved_requests_unless_denied

  belongs_to :cat
  belongs_to :leasee,
    class_name: "User",
    foreign_key: :user_id

  after_initialize { self.status ||= "PENDING" }

  def approve
    self.approve!
    true
  rescue
    false
  end

  def approve!
    CatRentalRequest.transaction do
      self.update!(status: "APPROVED")
      # fail
      overlapping_requests.each { |overlapper| overlapper.deny! }
    end
  end

  def deny!
    self.update!(status: "DENIED")
  end

  private

  def no_overlapping_approved_requests_unless_denied
    if !overlapping_approved_requests.empty?
      if status == "PENDING" || status == "APPROVED"
        errors[:cat_rental_request] << 'overlapping cat rental request'
      end
    end
  end

  def overlapping_requests
    where_string = <<-SQL
    (
        :start_date BETWEEN start_date AND end_date
      OR
        :end_date BETWEEN start_date AND end_date
      OR
        start_date BETWEEN :start_date AND :end_date
      OR
        end_date BETWEEN :start_date AND :end_date
    )
    AND
      cat_rental_requests.id != :id
    SQL

    where_string
    CatRentalRequest
      .where(where_string,
        id: self.id,
        start_date: self.start_date,
        end_date: self.end_date
      )
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end

end
