def calculate_booking_total(room_price, services_total, discount_percent=0, discount_amount=0, stay_duration=1):
    """Calculate real-time booking total with all components"""
    room_total = room_price * stay_duration
    subtotal = room_total + services_total
    
    if discount_percent > 0:
        discount_amount = (subtotal * discount_percent) / 100
    
    discounted_total = max(0, subtotal - discount_amount)
    tax_rate = 0.13
    tax_amount = discounted_total * tax_rate
    grand_total = discounted_total + tax_amount
    
    return {
        'room_total': room_total,
        'services_total': services_total,
        'discount_amount': discount_amount,
        'subtotal': subtotal,
        'tax_amount': tax_amount,
        'grand_total': grand_total
    }

def calculate_refund_amount(booking_amount, cancellation_type, days_before_checkin):
    """Calculate refund based on cancellation policy"""
    cancellation_policy = {
        'Before Check-in': {
            '48+ hours': 0.90,
            '24-48 hours': 0.50,
            'Less than 24 hours': 0.10
        },
        'After Check-in': {'default': 0.50},
        'No Show': {'default': 0.00}
    }
    
    if cancellation_type == 'Before Check-in':
        if days_before_checkin >= 2:
            refund_percentage = cancellation_policy['Before Check-in']['48+ hours']
        elif days_before_checkin >= 1:
            refund_percentage = cancellation_policy['Before Check-in']['24-48 hours']
        else:
            refund_percentage = cancellation_policy['Before Check-in']['Less than 24 hours']
    else:
        refund_percentage = cancellation_policy[cancellation_type]['default']
    
    refund_amount = booking_amount * refund_percentage
    cancellation_fee = booking_amount - refund_amount
    
    return refund_amount, cancellation_fee, refund_percentage * 100