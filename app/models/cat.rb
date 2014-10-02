class Cat < ActiveRecord::Base
  COLORS = %w(
    red
    cream
    chocolate
    lilac
    cinnamon
    fawn
    white
    black
    blue
  )

  validates :name, :sex, :color, :user_id, presence: true
  validate :birth_date_not_too_late
  validates :color, inclusion: { in: COLORS }
  #decided against this: validates :sex, inclusion: { in: w%{ M F }}
  has_many :requests,
    class_name: "CatRentalRequest",
    dependent: :destroy

  belongs_to :owner,
    class_name: "User",
    foreign_key: :user_id

  def age
    (Time.now - birth_date).year # test this
  end

  private

  def birth_date_not_too_late
    return if birth_date.nil?
    if birth_date > Date.current
      errors[:cat] << "No"
    end
    # validates(
    #   :birth_date,
    #   timeliness: {on_or_before: -> { Date.current }, type: :date}
    # )
  end

end
