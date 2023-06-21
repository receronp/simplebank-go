package util

const (
	USD = "USD"
	EUR = "EUR"
	MXN = "MXN"
)

func IsSupportedCurrency(currency string) bool {
	switch currency {
	case USD, EUR, MXN:
		return true
	default:
		return false
	}
}
