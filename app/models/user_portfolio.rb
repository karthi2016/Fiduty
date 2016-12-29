class UserPortfolio < ApplicationRecord
    belongs_to :user
    belongs_to :portfolio

  def self.recent_investments
    investments = UserPortfolio.find(:all, :order => "id desc", :limit => 25).reverse
    array = []
    investments.each do |investment|
      portfolio = Portfolio.find(investment.portfolio_id)
      user = user.find(investment.user_id)
      array.push({"portfolio": portfolio,"user": user})
    end
  end

  def calc_holding_return
    @portfolio = Portfolio.find(self.portfolio_id)
    YahooApi.update_ytd(@portfolio)
    currentYTD = @portfolio.ytd_raw
    holding_ret = currentYTD - self.ytd
    self.holding_return = holding_ret
    self.save
  end

  def calc_value
    self.calc_holding_return
    val = self.holding_return - self.inital_investment
    self.value = val
    self.save
  end

  def calc_gain_loss
    self.calc_value
    self.gain_loss = self.value - self.inital_investment
    self.save
  end

end
