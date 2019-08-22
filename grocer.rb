def consolidate_cart(cart)
  groceries_updated = cart.inject({}) do |consolidated, grocery|
    item = grocery.keys.first
    consolidated[item] ||= grocery[item].merge(count: 0)
    consolidated[item][:count] += 1
    consolidated
  end
end

def apply_coupons(cart, coupons) 
  coupons.each do |coupon| 
    coupon.each do |attribute, value| 
      name = coupon[:item] 
      if cart[name] && cart[name][:count] >= coupon[:num] 
        if cart["#{name} W/COUPON"] 
          cart["#{name} W/COUPON"][:count] += coupon[:num] 
        else 
          cart["#{name} W/COUPON"] = {:price => coupon[:cost]/coupon[:num], 
          :clearance => cart[name][:clearance], :count => coupon[:num]} 
        end 
        cart[name][:count] -= coupon[:num] 
      end 
    end 
  end 
  cart 
end

def apply_clearance(cart)
  cart.each do |item,value|
    if value[:clearance] 
      value[:price] = (value[:price] * 0.8).round(2)
    end 
  end
  cart
end

def checkout(cart, coupons)
  total = 0 
  result = apply_clearance(apply_coupons(consolidate_cart(cart),coupons))
  result.each do |item, value|
    total += result[item][:price] * result[item][:count]
  end
  if total > 100 
    return total *= 0.90 
  else
   return total
  end
end

def checkout(cart, coupons)
  new_cart = consolidate_cart(cart)
  w_coupons = apply_coupons(new_cart, coupons)
  w_clearance = apply_clearance(new_cart)
  final_cost = 0 
  w_clearance.each do |item, attribute|
    final_cost += (attribute[:price] * attribute[:count])
  end
  final_cost = (final_cost * 0.9) if final_cost > 100
end
