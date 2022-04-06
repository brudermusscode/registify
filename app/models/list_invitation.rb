class ListInvitation < ApplicationRecord
  after_touch :increase_use_count

  has_secure_token :token, length: 24
  belongs_to :list

  def increase_use_count
    self.use_count += 1
    save
  end

  def already_taken?(session_scope)
    ListPermission.where(list:, operator: session_scope).exists?
  end
end
