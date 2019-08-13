def consolidate_cart(cart)
  new_cart = {} 
    cart.each do |array_items|
      array_items.each do |hash_item, attribute_hash|
        new_cart[hash_item] ||= attribute_hash
        new_cart[hash_item][:count] ? new_cart[hash_item][:count] += 1 : new_cart[hash_item][:count] = 1 
      end
    end 
    new_cart 
end


def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    coupon.each do |attribute, value| 
      name = coupon[:item]
      
      if cart[name] && cart[name][:count] >= coupon[:num]
        if cart["#{name} W/COUPON"]
          cart["#{name} W/COUPON"][:count] += 2 
        else 
          cart["#{name} W/COUPON"] = {:price => coupon[:cost]/coupon[:num], :clearance => cart[name][:clearance], :count => coupon[:num]}
        end 
        
      cart[name][:count] -= coupon[:num] 
    end 
  end 
end 
  cart 
end


def apply_clearance(cart)
  cart.each do |hash_item, attribute_hash| 
    if attribute_hash[:clearance] == true 
      attribute_hash[:price] = (attribute_hash[:price]*0.80).round(2) 
    end 
  end 
  cart 
end


def checkout(cart, coupons)
  cart_total = 0 
  new_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(new_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart) 
  
  clearance_cart.each do |item, attribute_hash| 
    cart_total += (attribute_hash[:price] * attribute_hash[:count])
  end 
  
  cart_total = (cart_total * 0.9) if cart_total > 100
  
  cart_total 
end
