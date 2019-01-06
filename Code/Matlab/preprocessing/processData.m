function envelope = processData(response)

response = normaliseSignal(response);
envelope = moveRMS(response,20)';
offset = mean(envelope(envelope<0.01));
envelope = envelope - offset;
envelope = envelope;

end