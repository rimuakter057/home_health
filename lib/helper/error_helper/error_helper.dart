String extractServerMessage(Map response) {
  return response['message']
      ?? response['errorMessages']?[0]?['message']
      ?? response['error']?['message']
      ?? 'Something went wrong';
}