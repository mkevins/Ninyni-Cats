class Cat < ActiveRecord::Base
  COLORS = [
    "red",
    "cream",
    "chocolate",
    "lilac",
    "cinnamon",
    "fawn",
    "white",
    "black",
    "blue"
  ]

  validates :name, :sex, :color, presence: true
  validate :birth_date_not_too_late
  validates :color, inclusion: { in: COLORS }
  #decided against this: validates :sex, inclusion: { in: w%{ M F }}

  def age
    (Time.now - birth_date).year # test this
  end

  private

  def birth_date_not_too_late
    return if birth_date.nil?
    validates_date(
      :birth_date,
      timeliness: {on_or_before: -> { Date.current }}
    )
  end

end
